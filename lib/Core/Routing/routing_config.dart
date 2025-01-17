// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:stormymart_v2/Screens & Features/Profile/Coins/coins.dart';
import 'package:stormymart_v2/Screens & Features/Profile/profile.dart';
import 'package:stormymart_v2/Screens & Features/Search/search.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Cart/Presentation/cart.dart';
import 'package:stormymart_v2/Screens%20&%20Features/CheckOut/Presentation/checkout.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Home/Presentation/home.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Product/Presentation/product_screen.dart';
import '../../Screens & Features/Product/Bloc/product_bloc.dart';
import '../../Screens & Features/Profile/Wishlists/wishlist.dart';
import 'transition_animation.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    //home
    GoRoute(
      path: '/',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const HomePage(),
          transitionsBuilder: customTransitionBuilder,
        );
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'product/:productId', //
          builder: (BuildContext context, GoRouterState state) {
            return BlocProvider(
                create: (context) => ProductBloc(),
                child: ProductScreen(productId: state.pathParameters['productId'] ?? ""));
          },
        ),
      ],
    ),
    //search
    GoRoute(
      path: '/search',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: SearchPage(),
          transitionsBuilder: customTransitionBuilder,
        );
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'item/:searchItem',
          builder: (BuildContext context, GoRouterState state) {
            return SearchPage(keyword: state.pathParameters['searchItem'] ?? "");
          },
        ),
      ],
    ),
    //cart
    GoRoute(
      path: '/cart',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const Cart(),//FirebaseAuth.instance.currentUser != null ? Cart() : const CartLoginPage(),
          transitionsBuilder: customTransitionBuilder,
        );
      },
    ),
    //checkout
    GoRoute(
      path: '/checkout',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const CheckOut(),
          transitionsBuilder: customTransitionBuilder,
        );
      },
    ),
    //profile
    GoRoute(
      path: '/profile',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const Profile(),
          transitionsBuilder: customTransitionBuilder,
        );
      },
    ),
    GoRoute(
      path: '/wishlists',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const WishList(),
          transitionsBuilder: customTransitionBuilder,
        );
      },
    ),
    GoRoute(
      path: '/coin',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const Coins(),
          transitionsBuilder: customTransitionBuilder,
        );
      },
    ),
  ],
);
