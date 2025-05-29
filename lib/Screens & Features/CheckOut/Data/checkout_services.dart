// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:stormymart_v2/Screens%20&%20Features/CheckOut/Bloc/checkout_bloc.dart';
import 'package:stormymart_v2/Screens%20&%20Features/CheckOut/Bloc/checkout_state.dart';
import 'package:stormymart_v2/Screens%20&%20Features/CheckOut/Utils/checkout_variables.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Payment/Presentation/payment.dart';
import 'package:uuid/uuid.dart';
import '../../../Core/Notification/notification_sender.dart';
import '../Bloc/checkout_events.dart';

class CheckOutServices {
  Future<String> generateRandomID() async {
    Random random = Random();
    String randomID = '';
    const String chars = "0123456789abcdefghijklmnopqrstuvwxyz";

    for (int i = 0; i < 20; i++) {
      randomID += chars[random.nextInt(chars.length)];
    }

    return randomID;
  }

  void getPromoDiscountMoney(BuildContext context, String promoCode) async {
    final provider = BlocProvider.of<CheckoutBloc>(context);
    final checkoutState = provider.state;
    final promoSnapshot = await FirebaseFirestore.instance
        .collection('Promo Codes')
        .doc(promoCode)
        .get();

    double promoDiscount = promoSnapshot['discount'].toDouble();
    double promoDiscountAmount = (checkoutState.total / 100) * promoDiscount;

    double total = checkoutState.total - promoDiscountAmount;
    provider.add(IsPromoCodeFound(
        isPromoCodeFound: true, promoDiscountAmount: promoDiscountAmount));
    provider.add(UpdateTotal(total: total));
  }

  void promoCodeOnTapFunctions(BuildContext context, String promoCode) async {
    final provider = BlocProvider.of<CheckoutBloc>(context);
    final promoMoney = getPromoDiscountMoney(context, promoCode);

    await FirebaseFirestore.instance
        .collection('Promo Codes')
        .where(FieldPath.documentId, isEqualTo: promoCode)
        .get()
        .then((querySnapshot) async {
      if (querySnapshot.size > 0) {
        promoMoney;
      } else {
        provider.add(
            IsPromoCodeFound(isPromoCodeFound: false, promoDiscountAmount: 0));
      }
    });
  }

  Future<void> sendNotification() async {
    CollectionReference reference =
    FirebaseFirestore.instance.collection('/Admin Panel');

    QuerySnapshot querySnapshot = await reference.get();

    for (var doc in querySnapshot.docs) {
      if (doc.id != 'Sell Data') {
        final tokenSnapshot = await FirebaseFirestore.instance
            .collection('userTokens')
            .doc(doc.id)
            .get();

        String token = tokenSnapshot.get('token');

        await SendNotification.toSpecific(
            "Order Update", 'New Order Placed', token, 'BottomBar()');
      }
    }
  }

  Future<String> getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    const deviceIdKey = 'device_id';

    String? existingId = prefs.getString(deviceIdKey);
    if (existingId != null) return existingId;

    String newId = const Uuid().v4();
    await prefs.setString(deviceIdKey, newId);
    return newId;
  }

  Future<void> placeOrder(BuildContext context, String usedPromoCode) async {
    final goRouter = GoRouter.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final provider = BlocProvider.of<CheckoutBloc>(context);
    final state = provider.state;

    provider.add(UpdateIsLoading(isLoading: true));

    final firestore = FirebaseFirestore.instance;
    final userId = FirebaseAuth.instance.currentUser?.uid ?? await getDeviceId();
    final orderId = const Uuid().v4();

    await firestore.collection('Orders').doc(userId).set({'enable': true});

    final orderRef = firestore
        .collection('Orders')
        .doc(userId)
        .collection('Pending Orders')
        .doc(orderId);

    final batch = firestore.batch();

    batch.set(orderRef, {
      'usedPromoCode': usedPromoCode,
      'usedCoin': state.coinAmount,
      'total': state.total,
      'deliveryLocation': '${checkoutAddressController.text}, ${state.selectedDivision}',
      'time': FieldValue.serverTimestamp(),
      'paid': false,
      'name': checkoutNameController.text,
      'phoneNumber': checkoutPhnNumberController.text,
    });

    for (int i = 0; i < state.idList.length; i++) {
      final itemRef = orderRef.collection('orderLists').doc(const Uuid().v4());
      batch.set(itemRef, {
        'productId': state.idList[i],
        'quantity': state.quantityList[i],
        'selectedSize': state.sizeList[i],
        'variant': state.variantList[i],
      });

      final productRef = firestore.collection('Products').doc(state.idList[i]);
      batch.update(productRef, {
        'quantityAvailable': FieldValue.increment(-state.quantityList[i]),
      });

      final cartQuery = await firestore
          .collection('userData')
          .doc(userId)
          .collection('Cart')
          .where('id', isEqualTo: state.idList[i])
          .where('quantity', isEqualTo: state.quantityList[i])
          .where('variant', isEqualTo: state.variantList[i])
          .get();

      for (final cartDoc in cartQuery.docs) {
        batch.delete(cartDoc.reference);
      }
    }

    await batch.commit();
    await resetCoins(state);

    provider.add(UpdateIsLoading(isLoading: false));
    showOrderConfirmationMessage(messenger);
    goRouter.go('/');
  }

  Future<void> resetCoins(CheckOutState state) async {
    if (state.isUsingCoin) {
      await FirebaseFirestore.instance
          .collection('userData')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .update({
        'coins': 0,
      });
    }
  }

  void showOrderConfirmationMessage(ScaffoldMessengerState messenger) {
    messenger.showSnackBar(const SnackBar(
      duration: Duration(seconds: 10),
      content: Text('Congratulations 🎉, Your Order has been Placed. Our Order Confirmation Team will contact you soon!'),
    ));
  }

  void navigateToPaymentPage(BuildContext context, double transAmount, String transId) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => PaymentPage(transAmount: transAmount, transId: transId,),
    ));
  }

  num discountAmount(num percentage, num amount) {
    return amount * (percentage / 100);
  }

  num getDeliveryCharge(BuildContext context) {
    final provider = BlocProvider.of<CheckoutBloc>(context);
    switch(provider.state.selectedDivision){
      case 'Dhaka':
        return 70;
      case '':
      case 'Select City':
        return 0;
      default:
        return 120;
    }
  }

  num getTotal(CheckOutState state, BuildContext context) {
    return state.itemTotal + getDeliveryCharge(context);
  }
}