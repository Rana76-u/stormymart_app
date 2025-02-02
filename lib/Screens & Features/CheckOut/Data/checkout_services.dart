// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:stormymart_v2/Screens%20&%20Features/CheckOut/Bloc/checkout_bloc.dart';
import 'package:stormymart_v2/Screens%20&%20Features/CheckOut/Bloc/checkout_state.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Payment/Presentation/payment.dart';
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
    //Get all the admins Id's
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

  Future<void> placeOrder(BuildContext context, String usedPromoCode) async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final provider = BlocProvider.of<CheckoutBloc>(context);
    String randomID = await generateRandomID();

    provider.add(UpdateIsLoading(isLoading: true));

    await enableOrderCollection();

    await orderDetails(usedPromoCode, randomID, provider);

    await orderItems(provider.state, randomID);

    await resetCoins(provider.state);

    await sendNotification();

    provider.add(UpdateIsLoading(isLoading: false));

    showOrderConfirmationMessage(messenger);

    provider.add(UpdateIsLoading(isLoading: false));

    //navigateToPaymentPage(context, provider.state.total.toDouble(), await generateRandomID());
    navigator.push(MaterialPageRoute(
      builder: (context) => PaymentPage(transAmount: provider.state.total.toDouble(), transId: randomID,),
    ));
  }

  Future<void> enableOrderCollection() async {
    await FirebaseFirestore.instance
        .collection('Orders')
        .doc(FirebaseAuth.instance.currentUser?.uid ?? '')
        .set({'enable': true});
  }

  Future<void> orderDetails(
      String usedPromoCode, String randomID, CheckoutBloc provider) async {
    var state = provider.state;
    await FirebaseFirestore.instance
        .collection('Orders')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('Pending Orders')
        .doc(randomID)
        .set({
      'usedPromoCode': usedPromoCode,
      'usedCoin': state.coinAmount,
      'total': state.total,
      'deliveryLocation': '${state.selectedAddress}, ${state.selectedDivision}',
      'time': FieldValue.serverTimestamp(),
      'paid': false
    });
  }

  Future<void> orderItems(CheckOutState state, String randomID) async {
    for (int index = 0; index < state.idList.length; index++) {
      String randomOrderListDocID = await generateRandomID();
      await FirebaseFirestore.instance
          .collection('Orders')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('Pending Orders')
          .doc(randomID)
          .collection('orderLists')
          .doc(randomOrderListDocID)
          .set({
        'productId': state.idList[index],
        'quantity': state.quantityList[index],
        'selectedSize': state.sizeList[index],
        'variant': state.variantList[index],
      });

      //update quantity available
      await FirebaseFirestore.instance
          .collection('Products')
          .doc(state.idList[index])
          .update({
        'quantityAvailable': FieldValue.increment(-state.quantityList[index]),
      });

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('userData')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('Cart')
          .where('id', isEqualTo: state.idList[index])
          .where('quantity', isEqualTo: state.quantityList[index])
          .where('variant', isEqualTo: state.variantList[index])
          .get();

      for (var doc in querySnapshot.docs) {
        doc.reference.delete();
      }
    }
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
      content: Text('Congratulations 🎉, Your Order has been Placed.'),
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
}
