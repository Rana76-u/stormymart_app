// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:stormymart_v2/Screens%20&%20Features/Cart/Widgets/cart_widgets.dart';
import '../Bloc/cart_states.dart';
import 'cart_order_summary.dart';

Widget cartBuildBody(BuildContext context, CartState state) {
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
