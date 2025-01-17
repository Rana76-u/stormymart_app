// Flutter imports:
import 'package:flutter/material.dart';

Color sizeCardColor(int i, int sizeSelected) {
  if (sizeSelected == i) {
    return Colors.green;
  } else {
    return Colors.white;
  }
}
