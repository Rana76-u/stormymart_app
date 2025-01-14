import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sslcommerz/model/SSLCAdditionalInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCCustomerInfoInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCEMITransactionInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
import 'package:flutter_sslcommerz/model/SSLCShipmentInfoInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCTransactionInfoModel.dart';
import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
import 'package:flutter_sslcommerz/sslcommerz.dart';
import 'package:go_router/go_router.dart';
import 'package:stormymart_v2/Screens%20&%20Features/CheckOut/Bloc/checkout_bloc.dart';
import 'package:stormymart_v2/Screens%20&%20Features/CheckOut/Bloc/checkout_state.dart';
import 'package:stormymart_v2/Screens%20&%20Features/CheckOut/Data/checkout_onpress_functions.dart';

import '../../../Core/Notification/notification_sender.dart';
import '../Bloc/checkout_events.dart';


class CheckOutServices {

  Future<void> startSSLCommerzTransaction(BuildContext context, double transAmount ) async {
    Sslcommerz sslcommerz = Sslcommerz(
      initializer: SSLCommerzInitialization(
        ipn_url: "stormymart-43ea8.firebaseapp.com//ipn_listener/",
        multi_card_name: "visa,master,bkash",
        currency: SSLCurrencyType.BDT,
        product_category: "Food",
        sdkType: SSLCSdkType.TESTBOX,
        store_id: 'storm6731b4684e6c3',
        store_passwd: 'rana7262.',
        total_amount: transAmount,
        tran_id: "1231123131212",
      ),
    );

    sslcommerz
        .addShipmentInfoInitializer(
      sslcShipmentInfoInitializer: SSLCShipmentInfoInitializer(
        shipmentMethod: "yes",
        numOfItems: 5,
        shipmentDetails: ShipmentDetails(
            shipAddress1: "Ship address 1",
            shipCity: "Faridpur",
            shipCountry: "Bangladesh",
            shipName: "Ship name 1",
            shipPostCode: "7860"),
      ),
    )
        .addCustomerInfoInitializer(
      customerInfoInitializer: SSLCCustomerInfoInitializer(
        customerState: "Chattogram",
        customerName: "Abu Sayed Chowdhury",
        customerEmail: "abc@gmail.com",
        customerAddress1: "Anderkilla",
        customerCity: "Chattogram",
        customerPostCode: "200",
        customerCountry: "Bangladesh",
        customerPhone: "01521762061",
      ),
    )
        .addEMITransactionInitializer(
        sslcemiTransactionInitializer: SSLCEMITransactionInitializer(
            emi_options: 1, emi_max_list_options: 9, emi_selected_inst: 0))
        .addAdditionalInitializer(
      sslcAdditionalInitializer: SSLCAdditionalInitializer(
        valueA: "value a",
        valueB: "value b",
        valueC: "value c",
        valueD: "value d",
        extras: {"key": "key", "key2": "key2"},
      ),
    );

    SSLCTransactionInfoModel result = await sslcommerz.payNow();
    _displayPaymentStatus(result, context);
  }

  void _displayPaymentStatus(SSLCTransactionInfoModel result, BuildContext context) {
    String message;
    Color bgColor;

    switch (result.status?.toLowerCase()) {
      case "failed":
        message = "Transaction Failed";
        bgColor = Colors.red;
        break;
      case "closed":
        message = "SDK Closed by User";
        bgColor = Colors.orange;
        break;
      default:
        message =
        "Transaction ${result.status} - Amount: ${result.amount ?? 0}";
        bgColor = Colors.green;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message))
    );
  }

  Future<String> generateRandomID()  async {
    Random random = Random();
    String randomID  = '';
    const String chars = "0123456789abcdefghijklmnopqrstuvwxyz";

    for (int i = 0; i < 20; i++) {
      randomID += chars[random.nextInt(chars.length)];
    }

    return randomID;
  }

  void getPromoDiscountMoney(BuildContext context, String promoCode) async {
    final provider = BlocProvider.of<CheckoutBloc>(context);
    final checkoutState = provider.state;
    final promoSnapshot = await FirebaseFirestore
        .instance
        .collection('Promo Codes')
        .doc(promoCode).get();

    double promoDiscount = promoSnapshot['discount'].toDouble();
    double promoDiscountAmount = ( checkoutState.total / 100) * promoDiscount;

    double total = checkoutState.total - promoDiscountAmount;
    provider.add(IsPromoCodeFound(isPromoCodeFound: true, promoDiscountAmount: promoDiscountAmount));
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
        provider.add(IsPromoCodeFound(isPromoCodeFound: false, promoDiscountAmount: 0));
      }
    });
  }

  Future<void> sendNotification() async {

    //Get all the admins Id's
    CollectionReference reference = FirebaseFirestore.instance.collection('/Admin Panel');

    QuerySnapshot querySnapshot = await reference.get();

    for (var doc in querySnapshot.docs) {
      if(doc.id != 'Sell Data'){

        final tokenSnapshot = await FirebaseFirestore.instance.collection('userTokens')
            .doc(doc.id).get();

        String token = tokenSnapshot.get('token');

        await SendNotification.toSpecific(
            "Order Update",
            'New Order Placed',
            token,
            'BottomBar()'
        );
      }
    }
  }

  Future<void> placeOrder(BuildContext context, String usedPromoCode) async {
    CheckoutOnPressFunctions().onPayNowPressed(context, 100);
    ///todo: uncomment here for order placement
    /*final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    final provider = BlocProvider.of<CheckoutBloc>(context);

    provider.add(UpdateIsLoading(isLoading: true));

    String randomID = await generateRandomID();

    await enableOrderCollection();

    await orderDetails(usedPromoCode, randomID, provider);

    await orderItems(provider.state, randomID);

    await resetCoins(provider.state);

    //await sendNotification();

    provider.add(UpdateIsLoading(isLoading: false));

    showOrderConfirmationMessage(messenger);

    navigateToHomePage(router);*/
  }

  Future<void> enableOrderCollection() async {
    await FirebaseFirestore.instance
        .collection('Orders')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({'enable': true});
  }

  Future<void> orderDetails(
      String usedPromoCode, String randomID, CheckoutBloc provider) async {
    var state = provider.state;
    await FirebaseFirestore.instance
        .collection('Orders')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Pending Orders')
        .doc(randomID)
        .set({
      'usedPromoCode': usedPromoCode,
      'usedCoin': state.coinAmount,
      'total': state.total,
      'deliveryLocation': '${state.selectedAddress}, ${state.selectedDivision}',
      'time': FieldValue.serverTimestamp(),
    });
  }

  Future<void> orderItems(CheckOutState state, String randomID) async {
    for (int index = 0; index < state.idList.length; index++) {
      String randomOrderListDocID = await generateRandomID();
      await FirebaseFirestore.instance
          .collection('Orders')
          .doc(FirebaseAuth.instance.currentUser!.uid)
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
          .doc(FirebaseAuth.instance.currentUser!.uid)
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
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'coins': 0,});
    }
  }

  void showOrderConfirmationMessage(ScaffoldMessengerState messenger) {
    messenger.showSnackBar(const SnackBar(
      content: Text('Congratulations 🎉, Your Order has been Placed.'),
    ));
  }

  void navigateToHomePage(GoRouter router) {
    router.go('/');
  }

  num discountAmount(num percentage, num amount) {
    return amount * (percentage/100);
  }

}