// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

// Project imports:
import 'package:stormymart_v2/Core/Bottom%20Navigation/Presentation/bottom_nav_bar.dart';
import 'package:stormymart_v2/Core/theme/color.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Auth/Presentation/login_widgeds.dart';
import 'package:stormymart_v2/Screens%20&%20Features/User/Data/user_hive.dart';
import '../Data/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;

  void loginOnPressFunctions() {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    GoRouter.of(context);

    setState(() {
      isLoading = true;
    });

    //await Authservice().signInWithGoogle();
    AuthService().signInWithGoogle().then((_) async {
      // Check if the box is already open before opening it
      if (!Hive.isBoxOpen('userInfo')) {
        await Hive.openBox('userInfo');
      }

      UserHive().updateUserData();

      setState(() {
        isLoading = false;
      });

      //router.push('/profile');
      navigator.push(MaterialPageRoute(
        builder: (context) => BottomBar(),
      ));
    })
        .catchError((error) {
      // Handle any error that occurred during sign-in
      messenger.showSnackBar(
          SnackBar(
              content: Text('Error: $error')
          )
      );

      debugPrint('Error: $error');

      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBgColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            LoginWidgets().topTexts(),

            //Login Button
            isLoading ?
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: const LinearProgressIndicator(),
            )
                :
            LoginWidgets().loginButton(context, loginOnPressFunctions)
          ],
        ),
      ),
    );
  }
}
