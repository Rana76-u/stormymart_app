// Flutter imports:
import 'package:flutter/material.dart';
import 'footer_widgets.dart' ;

Widget coreFooter() {
  return Container(
    width: double.infinity,
    color: Colors.black,
    child: Padding(
      padding: const EdgeInsets.only(left: 50, right: 50, bottom: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FooterWidgets().support(),

          FooterWidgets().company(),

          FooterWidgets().terms(),

          FooterWidgets().address(),

          const Padding(padding: EdgeInsets.only(top: 10), child: Divider()),

          FooterWidgets().icons(),

          const Padding(padding: EdgeInsets.only(top: 30), child: Divider()),

          FooterWidgets().rights()
        ],
      ),
    ),
  );
}


