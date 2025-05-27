import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../Screens & Features/Home/Bloc/home_state.dart';
import '../Widgets/appbar_widget.dart';

Widget coreAppBarDesktopNewUI(BuildContext context, HomeState state) {
  return AppBar(
    backgroundColor: Colors.black,
    elevation: 10,
    toolbarHeight: 100,
    title: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Row(
        children: [
          AppBarWidgets().logo(context),

          const SizedBox(width: 40),

          // Navigation menu items
          TextButton(
            onPressed: () => GoRouter.of(context).go('/'),
            child: const Text('Home', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => GoRouter.of(context).go('/about'),
            child: const Text('About Us', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => GoRouter.of(context).go('/contact'),
            child: const Text('Contact Now', style: TextStyle(color: Colors.white)),
          ),

          const Expanded(child: SizedBox()),

          AppBarWidgets().searchIcon(context),

          const SizedBox(width: 30),

          AppBarWidgets().cartIcon(context),

          const SizedBox(width: 30),

          AppBarWidgets().myOrderHistory(context),
        ],
      ),
    ),
  );
}
