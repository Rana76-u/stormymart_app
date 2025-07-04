
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stormymart_v2/Screens%20&%20Features/CheckOut/Bloc/checkout_state.dart';
import '../Bloc/checkout_bloc.dart';
import '../Bloc/checkout_events.dart';
import '../Utils/checkout_variables.dart';
import 'checkout_services.dart';

void placeOrderFunctions(BuildContext context, CheckOutState state) async {
  final provider = BlocProvider.of<CheckoutBloc>(context);

  if(checkoutNameController.text.isNotEmpty &&
      checkoutPhnNumberController.text.isNotEmpty &&
      checkoutAddressController.text.isNotEmpty &&
      state.selectedDivision != '' &&
      state.selectedDivision != 'Select City'
  ) {

    provider.add(UpdateIsLoading(isLoading: true));

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