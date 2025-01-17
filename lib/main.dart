// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Project imports:
import 'package:stormymart_v2/Screens%20&%20Features/Cart/Bloc/cart_bloc.dart';
import 'package:stormymart_v2/Screens%20&%20Features/CheckOut/Bloc/checkout_bloc.dart';
import 'package:stormymart_v2/Screens%20&%20Features/User/Data/user_hive.dart';
import 'package:stormymart_v2/firebase_options.dart';
import 'Core/Routing/routing_config.dart';
import 'Screens & Features/Home/Bloc/home_bloc.dart';
import 'Screens & Features/Product/Bloc/product_bloc.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  await Hive.initFlutter();
  // Check if the box is already open before opening it
  if (!Hive.isBoxOpen('userInfo')) {
    await Hive.openBox('userInfo');
  }//if open then
  else{
    //check if userUID field is there or not, representing user's login state
    if(Hive.box('userInfo').containsKey('userUid')){
      UserHive().updateUserData();
    }
  }

  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HomeBloc()),
        BlocProvider(create: (context) => CartBloc()),
        BlocProvider(create: (context) => CheckoutBloc()),
        BlocProvider(create: (context) => ProductBloc()),
      ],
      child: MaterialApp.router(
        title: 'StormyMart',
        theme: ThemeData(
          primaryColor: WidgetStateColor.resolveWith((states) => const Color(0xFFFAB416))
        ),
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}


