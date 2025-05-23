// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:stormymart_v2/Screens%20&%20Features/Cart/Widgets/cart_widgets.dart';
import '../Bloc/cart_states.dart';
import 'cart_order_summary.dart';

Widget cartBuildBodyMobile(BuildContext context, CartState state) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CartWidgets().cartTitle(),
      CartWidgets().numberOfItemsWidget(state.idList.length),
      CartWidgets().selectAllWidget(context, state),
      CartWidgets().cartItems(state),
      OrderSummary(cartState: state),
      CartWidgets().checkOutButton(context, state),

      const SizedBox(height: 80,)
    ],
  );
}

Widget cartBuildBodyDesktop(BuildContext context, CartState state) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CartWidgets().cartTitle(),
        const SizedBox(height: 10),
        CartWidgets().numberOfItemsWidget(state.idList.length),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left side: Cart items
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CartWidgets().selectAllWidget(context, state),
                  const SizedBox(height: 10),
                  CartWidgets().cartItems(state),
                ],
              ),
            ),

            const SizedBox(width: 30),

            // Right side: Order Summary
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OrderSummary(cartState: state),
                  const SizedBox(height: 20),
                  CartWidgets().checkOutButton(context, state),
                ],
              ),
            )
          ],
        ),

        const SizedBox(height: 40),

        Align(
          alignment: Alignment.bottomRight,
          child: CartWidgets().floatingButtonWidget(state, context),
        )
      ],
    ),
  );
}
