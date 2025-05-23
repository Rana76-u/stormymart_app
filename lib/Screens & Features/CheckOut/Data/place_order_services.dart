
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Bloc/checkout_bloc.dart';
import '../Bloc/checkout_events.dart';
import '../Utils/checkout_variables.dart';
import 'checkout_services.dart';

void placeOrderFunctions(BuildContext context) async {
  final provider = BlocProvider.of<CheckoutBloc>(context);

  if(checkoutNameController.text.isNotEmpty &&
      checkoutPhnNumberController.text.isNotEmpty &&
      checkoutAddressController.text.isNotEmpty) {

    provider.add(UpdateIsLoading(isLoading: true));

    provider.add(ChangeUserInfoEvent(
        name: checkoutNameController.text,
        phoneNumber: checkoutPhnNumberController.text,
        address: checkoutAddressController.text)
    );

    await CheckOutServices()
        .placeOrder(context, checkoutPromoCodeController.text);

  }
  else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please fill all the fields'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}