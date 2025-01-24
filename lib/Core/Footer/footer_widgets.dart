import 'package:flutter/material.dart';

class FooterWidgets{
  Widget footerTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          letterSpacing: 2
        ),
      ),
    );
  }

  Widget footerSubTitle(String text, String route) {
    return GestureDetector(
      onTap: () {
        //GoRouter.of(context).push('/$route');
      },
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget iconTextItems(IconData iconData, Color color, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(iconData, color: color,),
        const SizedBox(width: 10,),
        Text(
          text,
          style: const TextStyle(
              color: Colors.amber
          ),
        ),
      ],
    );
  }

  Widget customIcon(IconData iconData) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(50)
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Icon(iconData, color: Colors.white,),
      ),
    );
  }

  Widget support() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FooterWidgets().footerTitle("SUPPORT"),
        iconTextItems(Icons.phone, Colors.white, '+880 1521762061'),
        iconTextItems(Icons.email, Colors.white, 'rafiqulislamrana76@gmail.com'),
        FooterWidgets().footerSubTitle("FAQ", ""),
      ],
    );
  }

  Widget company() {
    return Column(
      children: [
        FooterWidgets().footerTitle("Company"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FooterWidgets().footerSubTitle("About Us", ""),
            FooterWidgets().footerSubTitle("Gallery", ""),
            FooterWidgets().footerSubTitle("Brand", ""),
          ],
        ),
      ],
    );
  }

  Widget terms() {
    return Column(
      children: [
        FooterWidgets().footerTitle("Terms & Conditions"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FooterWidgets().footerSubTitle("Terms & Conditions", ""),
            FooterWidgets().footerSubTitle("Privacy Policy", ""),
          ],
        )
      ],
    );
  }

  Widget address() {
    return Column(
      children: [
        footerTitle('StormyMart Ltd'),
        footerSubTitle('Head Office: Dakhingaon rd no. 02, Sabujhbagh, Dhaka-1214', '')
      ],
    );
  }
  
  Widget icons() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          customIcon(Icons.facebook),
          customIcon(Icons.whatshot),
          customIcon(Icons.linked_camera),
          customIcon(Icons.pin_drop),
        ],
      ),
    );
  }

  Widget rights() {
    return Text(
      '© 2024 StormyMart Ltd | All rights reserved',
      style: TextStyle(
        color: Colors.grey.shade400
      ),
    );
  }
}