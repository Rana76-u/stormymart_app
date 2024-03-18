import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stormymart_v2/Blocks/Cart%20Bloc/cart_bloc.dart';
import 'package:stormymart_v2/Blocks/CheckOut%20Bloc/checkout_bloc.dart';
import 'package:stormymart_v2/Screens/Cart/cart.dart';
import 'package:stormymart_v2/Screens/CheckOut/checkout.dart';
import 'package:stormymart_v2/Screens/Home/home.dart';
import 'package:stormymart_v2/Screens/Product%20Screen/product_screen.dart';
import 'package:stormymart_v2/Screens/Profile/profile.dart';
import 'package:stormymart_v2/Screens/Search/search.dart';
import 'package:stormymart_v2/firebase_options.dart';

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
            return ProductScreen(productId: state.pathParameters['productId'] ?? ""); //"9wvb79aljlo43kjnwf3k"
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
          path: 'searchTerm/:searchItem',
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
    //cart
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
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CartBloc()),
        BlocProvider(create: (context) => CheckoutBloc()),
      ],
      child: MaterialApp.router(
        title: 'StormyMart',
        theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Urbanist'),
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}


