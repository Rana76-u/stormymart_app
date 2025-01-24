// Flutter imports:
import 'package:flutter/material.dart';

EdgeInsets paddingProvider(BuildContext context) {

  double padding = 0;

  if(MediaQuery.of(context).size.width <= 600) {
    padding =  5;
  }
  else if(MediaQuery.of(context).size.width <= 1565) {
    padding = MediaQuery.of(context).size.width*0.065;
  }
  else {
    padding = MediaQuery.of(context).size.width*0.15;
  }

  return EdgeInsets.symmetric(horizontal: padding);
}
