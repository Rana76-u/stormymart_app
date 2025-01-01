import 'package:flutter/material.dart';

Widget homeFooter() {
  return Container(
    height: 300,
    width: double.infinity,
    color: Colors.black,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            footerTitle("Company"),
            footerSubTitle("About Us", ""),
            footerSubTitle("Gallery", ""),
            footerSubTitle("Brand Collaboration", ""),
          ],
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            footerTitle("Help Center"),
            footerSubTitle("FAQ", ""),
            footerSubTitle("Support Center", ""),
          ],
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            footerTitle("Terms & Conditions"),
            footerSubTitle("Terms & Conditions", ""),
            footerSubTitle("Privacy Policy", ""),
          ],
        ),
      ],
    ),
  );
}

Widget footerTitle(String text) {
  return Padding(
    padding: const EdgeInsets.only(top: 50, bottom: 30),
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    ),
  );
}

Widget footerSubTitle(String text, String route) {
  return GestureDetector(
    onTap: () {
      //GoRouter.of(context).go('/$route');
    },
    child: Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    ),
  );
}
