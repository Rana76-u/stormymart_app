// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:stormymart_v2/Screens%20&%20Features/CheckOut/Bloc/checkout_state.dart';
import 'package:stormymart_v2/Screens%20&%20Features/CheckOut/Data/checkout_services.dart';
import '../Bloc/checkout_bloc.dart';
import '../Bloc/checkout_events.dart';
import '../Utils/checkout_variables.dart';
import 'checkout_widgets.dart';

Widget checkoutOrderSummaryCard(BuildContext context, CheckOutState state) {
  final provider = BlocProvider.of<CheckoutBloc>(context);

  return Card(
    elevation: 0,
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CheckoutWidgets().titlesWidget('Order Summary'),

          CheckoutWidgets().itemsWidget(state),

          CheckoutWidgets().promoWidget(context, state, checkoutPromoCodeController),

          CheckoutWidgets().coinWidget(context, state),

          Divider(color: Colors.grey.shade300,),

          CheckoutWidgets().orderSummaryText('Subtotal', '৳ ${state.itemTotal}'),

          CheckoutWidgets().orderSummaryText(
              'App Discount', 
              '৳ -${CheckOutServices().discountAmount(5, state.itemTotal).toStringAsFixed(1)}'),

          CheckoutWidgets().orderSummaryText('Delivery Fee', '৳ 120/-'),

          CheckoutWidgets().orderSummaryText('Promo Discount', '-৳ ${state.promoDiscountAmount}'),

          Visibility(
            visible: state.isUsingCoin ? true : false,
            child: CheckoutWidgets().orderSummaryText(
                'Coin Discount', '-৳ ${state.coinAmount / 1000}'),
          ),

          const Divider(),

          CheckoutWidgets().titlesWidget('Total : ৳ ${state.total}'),

          const SizedBox(height: 35,),

          CheckoutWidgets().buttonWidget(
              48, double.infinity, Colors.green, 'Place Order', () async {

                provider.add(UpdateIsLoading(isLoading: true));

                provider.add(ChangeUserInfoEvent(
                name: checkoutNameController.text,
                phoneNumber: checkoutPhnNumberController.text,
                address: checkoutAddressController.text));

                await CheckOutServices()
                .placeOrder(context, checkoutPromoCodeController.text);

          }),

          const SizedBox(height: 10,),
        ],
      ),
    ),
  );
}
