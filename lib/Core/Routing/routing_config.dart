// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:stormymart_v2/Screens & Features/Profile/Coins/coins.dart';
import 'package:stormymart_v2/Screens & Features/Profile/profile.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Cart/Presentation/cart.dart';
import 'package:stormymart_v2/Screens%20&%20Features/CheckOut/Presentation/checkout.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Home/Presentation/home.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Product/Presentation/product_screen.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Search/Bloc/search_bloc.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Search/Bloc/search_events.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Search/Presentation/search.dart';
import '../../Screens & Features/Product/Bloc/product_bloc.dart';
import '../../Screens & Features/Product/Bloc/product_events.dart';
import '../../Screens & Features/Profile/Wishlists/wishlist.dart';
import '../Bottom Navigation/Presentation/bottom_nav_bar.dart';
import 'transition_animation.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return Scaffold(
          body: child,
          bottomNavigationBar: BottomBar(),
        );
      },
      routes: [
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
                final blocProvider = BlocProvider.of<ProductBloc>(context);
                blocProvider.add(UpdateProductID(state.pathParameters['productId'] ?? ""));

                return BlocProvider(
                    create: (context) => ProductBloc(),
                    child: ProductScreen(productId: state.pathParameters['productId'] ?? ""));
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
              child: const Cart(),
              transitionsBuilder: customTransitionBuilder,
            );
          },
        ),

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
      ],
    ),

    //search
    GoRoute(
      path: '/search',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const SearchPage(),
          transitionsBuilder: customTransitionBuilder,
        );
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'item/:searchItem',
          builder: (BuildContext context, GoRouterState state) {
            BlocProvider.of<SearchBloc>(context).add(UpdateSearchedText(state.pathParameters['searchItem'] ?? ""));
            return const SearchPage();
          },
        ),
      ],
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
    //wishlist
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
    //coin
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
