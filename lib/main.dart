import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stormymart_v2/Blocks/Cart%20Bloc/cart_bloc.dart';
import 'package:stormymart_v2/Blocks/CheckOut%20Bloc/checkout_bloc.dart';
import 'package:stormymart_v2/Screens & Features/Cart/cart.dart';
import 'package:stormymart_v2/Screens & Features/CheckOut/checkout.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Home/Presentation/home.dart';
import 'package:stormymart_v2/Screens & Features/Product%20Screen/product_screen.dart';
import 'package:stormymart_v2/Screens & Features/Profile/Coins/coins.dart';
import 'package:stormymart_v2/Screens & Features/Profile/profile.dart';
import 'package:stormymart_v2/Screens & Features/Search/search.dart';
import 'package:stormymart_v2/firebase_options.dart';
import 'Screens & Features/Home/Bloc/home_bloc.dart';
import 'Screens & Features/Home/show_all_hotdeals.dart';
import 'Screens & Features/Profile/Wishlists/wishlist.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(const MyApp());
}

Widget _customTransitionBuilder(BuildContext context, Animation<double> animation,
    Animation<double> secondaryAnimation, Widget child) {
  return FadeTransition(
    opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
    child: child,
  );
}

/// The route configuration.
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    //home
    GoRoute(
      path: '/',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const HomePage(),
          transitionsBuilder: _customTransitionBuilder,
        );
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'product/:productId', //
          builder: (BuildContext context, GoRouterState state) {
            return ProductScreen(productId: state.pathParameters['productId'] ?? "");
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
          transitionsBuilder: _customTransitionBuilder,
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
          transitionsBuilder: _customTransitionBuilder,
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
          transitionsBuilder: _customTransitionBuilder,
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
          transitionsBuilder: _customTransitionBuilder,
        );
      },
    ),
    GoRoute(
      path: '/hotdeals',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const ShowAllHotDeals(),
          transitionsBuilder: _customTransitionBuilder,
        );
      },
    ),
    GoRoute(
      path: '/wishlists',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const WishList(),
          transitionsBuilder: _customTransitionBuilder,
        );
      },
    ),
    GoRoute(
      path: '/coin',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const Coins(),
          transitionsBuilder: _customTransitionBuilder,
        );
      },
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HomeBloc()),
        BlocProvider(create: (context) => CartBloc()),
        BlocProvider(create: (context) => CheckoutBloc()),
      ],
      child: MaterialApp.router(
        title: 'StormyMart',
        theme: ThemeData(
          primaryColor: WidgetStateColor.resolveWith((states) => const Color(0xFFFAB416))
        ),
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}


