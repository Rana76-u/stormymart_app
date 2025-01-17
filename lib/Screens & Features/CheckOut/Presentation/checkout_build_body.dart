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

Widget checkoutBuildBody(BuildContext context) {
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
              padding:
                  EdgeInsets.symmetric(horizontal: paddingProvider(context), vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CheckoutWidgets().checkOutTitle(),

                  billingInfoCard(context),

                  checkoutOrderSummaryCard(context, state),
                ],
              ),
            );
    },
  );
}
