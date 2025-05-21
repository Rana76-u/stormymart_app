// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'footer_widgets.dart' ;

Widget coreFooterMobile() {
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


Widget coreFooterDesktop() {
  return Container(
    width: double.infinity,
    color: Colors.black,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: FooterWidgets().support(),
              ),
              Expanded(
                flex: 2,
                child: FooterWidgets().company(),
              ),
              Expanded(
                flex: 2,
                child: FooterWidgets().terms(),
              ),
              Expanded(
                flex: 4,
                child: FooterWidgets().address(),
              ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.only(top: 30),
            child: Divider(
              color: Colors.grey,
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FooterWidgets().icons(),
                FooterWidgets().rights(),
              ],
            ),
          )
        ],
      ),
    ),
  );
}
