

import 'package:flutter/cupertino.dart';
import 'package:stormymart_v2/Screens%20&%20Features/CheckOut/Data/checkout_services.dart';

class CheckoutOnPressFunctions {
  Future<void> onPayNowPressed(BuildContext context, double transAmount) async {
    CheckOutServices().startSSLCommerzTransaction(context, transAmount);
  }
}