
import 'package:flutter/material.dart';

double paddingProvider(BuildContext context) {
  if(MediaQuery.of(context).size.width <= 600) {
    return 0;
  }
  else if(MediaQuery.of(context).size.width <= 1565) {
    return MediaQuery.of(context).size.width*0.065;
  }
  else {
    return MediaQuery.of(context).size.width*0.15;
  }
}