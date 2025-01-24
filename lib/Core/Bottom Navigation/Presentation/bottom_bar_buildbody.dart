import 'package:flutter/material.dart';
import '../../../Screens & Features/Cart/Presentation/cart.dart';
import '../../../Screens & Features/Home/Presentation/home.dart';
import '../../../Screens & Features/Profile/profile.dart';

Widget bottomBarBuildBody(BuildContext context, int index) {
  switch (index) {
    case 0:
      return const HomePage();
    case 1:
      return const Cart();
    case 2:
      return const Profile();
    default:
      return const SizedBox();
  }
}