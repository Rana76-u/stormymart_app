import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stormymart_v2/Core/Bottom%20Navigation/Presentation/bottom_bar_buildbody.dart';
import '../Bloc/bottom_bar_bloc.dart';
import '../Bloc/bottom_bar_events.dart';
import '../Bloc/bottom_bar_state.dart';

class BottomBar extends StatelessWidget {
   BottomBar({super.key});

  final List<String> _routes = [
    '/',         // Home
    '/cart',     // Cart
    '/profile',  // Profile
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BottomBarBloc(),
      child: BlocBuilder<BottomBarBloc, BottomBarState>(
        builder: (context, state) {
          return Scaffold(
            body: bottomBarBuildBody(context, state.index),
            bottomNavigationBar: FlashyTabBar(
              animationCurve: Curves.linear,
              selectedIndex: state.index,
              iconSize: 25,
              showElevation: false,
              onItemSelected: (index) {
                context.read<BottomBarBloc>().add(BottomBarSelectedItem(index));
                context.go(_routes[index]);
              },
              items: [
                FlashyTabBarItem(
                  icon: const Icon(Icons.home_rounded),
                  title: const Text('Home'),
                ),
                FlashyTabBarItem(
                  icon: const Icon(Icons.shopping_cart),
                  title: const Text('Cart'),
                ),
                FlashyTabBarItem(
                  icon: const Icon(Icons.person),
                  title: const Text('Profile'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }



}