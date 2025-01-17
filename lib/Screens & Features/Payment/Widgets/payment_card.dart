// Flutter imports:
import 'package:flutter/material.dart';

Widget paymentCard() {
  return Card(
    color: Colors.white,
    elevation: 0,
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              'https://i.imgur.com/QH1SUwO.jpg',
              fit: BoxFit.fill,
            ),
          )
        ],
      ),
    ),
  );
}
