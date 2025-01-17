// Flutter imports:
import 'package:flutter/material.dart';

Widget customTransitionBuilder(BuildContext context, Animation<double> animation,
    Animation<double> secondaryAnimation, Widget child) {
  return FadeTransition(
    opacity: CurveTween(curve: Curves.bounceInOut).animate(animation),
    child: child,
  );
}



