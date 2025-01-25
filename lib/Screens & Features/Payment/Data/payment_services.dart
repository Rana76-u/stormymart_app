// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
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

// Project imports:
import '../../User/Data/user_hive.dart';

class PaymentServices {

  Future<void> startSSLCommerzTransaction(
      BuildContext context, double transAmount, String transId) async {
    Sslcommerz sslcommerz = Sslcommerz(
      initializer: SSLCommerzInitialization(
        //ipn_url: "stormymart-43ea8.firebaseapp.com//ipn_listener/",
        multi_card_name: "visa,master,bkash",
        currency: SSLCurrencyType.BDT,
        product_category: "E-Commerce",
        sdkType: SSLCSdkType.TESTBOX,
        store_id: 'storm6731b4684e6c3',
        store_passwd: 'storm6731b4684e6c3@ssl',
        total_amount: transAmount,
        tran_id: transId,
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
    _displayPaymentStatus(result, context, transId);
  }

  void _displayPaymentStatus(
      SSLCTransactionInfoModel result, BuildContext context, String transId) {
    String message;

    switch (result.status?.toLowerCase()) {
      case 'valid':
        message = "Transaction Completed";
        updatePaymentStatusInOrderDetails(transId);
        navigateToHome(context);
        break;
      case "failed":
        message = "Transaction Failed";
        break;
      case "closed":
        message = "SDK Closed by User";
        break;
      default:
        message =
        "Transaction ${result.status} - Amount: ${result.amount ?? 0}";
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void navigateToHome(BuildContext context) {
    GoRouter.of(context).push('/');
  }

  Future<void> updatePaymentStatusInOrderDetails(String orderId) async {
    await FirebaseFirestore.instance
        .collection('Orders')
        .doc(UserHive().getUserUid())
        .collection('Pending Orders')
        .doc(orderId)
        .update({
      'paid': true
    });
  }

}
