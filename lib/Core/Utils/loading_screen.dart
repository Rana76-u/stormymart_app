import 'package:flutter/material.dart';
import 'package:stormymart_v2/Core/Utils/core_progress_bars.dart';

Widget showLoadingScreen(String text) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        centeredCircularProgress(),

        const SizedBox(height: 20,),

        Text(text,
        style: const TextStyle(
          color: Colors.grey
        ),),
      ],
    ),
  );
}