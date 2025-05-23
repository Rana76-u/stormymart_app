// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:stormymart_v2/Screens%20&%20Features/Cart/Bloc/cart_states.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Cart/Presentation/cart_order_summary_widgets.dart';
import '../Data/cart_services.dart';

class OrderSummary extends StatelessWidget {
  final CartState cartState;
  const OrderSummary({super.key, required this.cartState});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OrderSummaryWidgets().title(),

          const SizedBox(height: 10,),

          OrderSummaryWidgets().listOfItemCalculations(context, cartState),

          const Divider(),

          OrderSummaryWidgets().summaryTexts('Sub Total:', "BDT ${CartServices().getCartSelectedItemTotal(cartState).toStringAsFixed(1)}"),

          //OrderSummaryWidgets().appDiscount(cartState, 5),

          //OrderSummaryWidgets().summaryTexts('Delivery Charge:', 'BDT 120'),

          //const Divider(),

          //OrderSummaryWidgets().summaryTexts('Total:', CartServices().getCartSelectedItemTotal(cartState).toStringAsFixed(1)),
        ],
      ),
    );
  }
}


