// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:stormymart_v2/Screens%20&%20Features/CheckOut/Utils/checkout_variables.dart';
import 'checkout_widgets.dart';

Widget billingInfoCard(BuildContext context) {
  return Card(
    color: Colors.white,
    elevation: 0,
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CheckoutWidgets().titlesWidget('Contact Info'),

          //Textbox for Full Name
          CheckoutWidgets().textBox(37, double.infinity, checkoutNameController,
              "Full Name", const Icon(Icons.abc), TextInputType.text),
          const SizedBox(height: 5,),
          //Textbox for Number
          CheckoutWidgets().textBox(
              37,
              double.infinity,
              checkoutPhnNumberController,
              "Phone Number",
              const Icon(Icons.onetwothree),
              TextInputType.phone),
          // --------------------------------
          const Divider(
            height: 20,
            color: Colors.white,
          ),
          // --------------------------------
          //Textbox for Address
          CheckoutWidgets().titlesWidget('Shipping Info'),
          CheckoutWidgets().textBox(
              37,
              double.infinity,
              checkoutAddressController,
              "Address",
              const Icon(Icons.location_on_rounded),
              TextInputType.streetAddress),
          // --------------------------------

          CheckoutWidgets().divisionPicker(context, checkoutDivisionController),
          //CheckoutWidgets().estimatedDelivery(),
        ],
      ),
    ),
  );
}
