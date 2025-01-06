import 'package:flutter/material.dart';

Color variationCardColor(int i, int variationSelected) {
  if (variationSelected == i) {
    return Colors.green;
  } else {
    return Colors.blueGrey;
  }
}