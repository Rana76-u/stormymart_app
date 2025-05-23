// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:stormymart_v2/Core/Utils/core_progress_bars.dart';
import 'package:stormymart_v2/Screens%20&%20Features/CheckOut/Widgets/billing_card.dart';
import 'package:stormymart_v2/Screens%20&%20Features/CheckOut/Widgets/order_summary_card.dart';
import '../../../Core/Utils/padding_provider.dart';
import '../Bloc/checkout_bloc.dart';
import '../Bloc/checkout_events.dart';
import '../Bloc/checkout_state.dart';
import '../Utils/checkout_variables.dart';
import '../Widgets/checkout_widgets.dart';

Widget checkoutBuildBodyMobile(BuildContext context) {
  final provider = BlocProvider.of<CheckoutBloc>(context);
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    provider.add(LoadUserDataEvent(uid: user.uid));
  } else {
    provider.add(UpdateIsLoading(isLoading: false));
  }

  return BlocBuilder<CheckoutBloc, CheckOutState>(
    builder: (context, state) {
      if (state.userName.isNotEmpty) {
        checkoutNameController.text = state.userName;
        checkoutPhnNumberController.text = state.phoneNumber;
        checkoutAddressController.text = state.selectedAddress;
        checkoutDivisionController.text = state.selectedDivision;
      }

      return state.isLoading
          ? centeredLinearProgress(context)
          : Padding(
              padding: paddingProvider(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20,),

                  CheckoutWidgets().checkOutTitle(),

                  billingInfoCard(context),

                  checkoutOrderSummaryCard(context, state),
                ],
              ),
            );
    },
  );
}

Widget checkoutBuildBodyDesktop(BuildContext context) {
  final provider = BlocProvider.of<CheckoutBloc>(context);
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    provider.add(LoadUserDataEvent(uid: user.uid));
  } else {
    provider.add(UpdateIsLoading(isLoading: false));
  }

  return BlocBuilder<CheckoutBloc, CheckOutState>(
    builder: (context, state) {
      if (state.userName.isNotEmpty) {
        checkoutNameController.text = state.userName;
        checkoutPhnNumberController.text = state.phoneNumber;
        checkoutAddressController.text = state.selectedAddress;
        checkoutDivisionController.text = state.selectedDivision;
      }

      return state.isLoading
          ? centeredLinearProgress(context)
          : Padding(
        padding: paddingProvider(context),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Side: Billing Info
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30,),
                  CheckoutWidgets().checkOutTitle(),
                  const SizedBox(height: 20),
                  billingInfoCard(context),
                ],
              ),
            ),

            const SizedBox(width: 30),

            // Right Side: Order Summary
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  const SizedBox(height: 50,),
                  checkoutOrderSummaryCard(context, state),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}