import 'package:flutter/material.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Cart/Widgets/cart_widgets.dart';
import '../Bloc/cart_states.dart';
import 'cart_order_summary.dart';

Widget cartBuildBody(BuildContext context, CartState state) {
  return Column(
    children: [
      const SizedBox(
        height: 50,
      ),

      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CartWidgets().numberOfItemsWidget(state.idList.length),
          CartWidgets().cartItems(state),
          OrderSummary(cartState: state),
        ],
      ),

      const SizedBox(
        height: 150,
      )
    ],
  );
}