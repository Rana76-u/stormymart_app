import 'package:flutter/material.dart';

class PlatformDetector {
  bool isMobile(BuildContext context) {
    if(MediaQuery.of(context).size.width <= 600){
      return true;
    }
    else{
      return false;
    }
  }
}