// Flutter imports:
import 'package:flutter/material.dart';

class LoginWidgets {

  Widget topTexts() {
    return const Column(
      children: [
        Text(
          'Welcome to',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w200,
          ),
        ),
        Text(
          'StormyMart',
          style: TextStyle(
            fontSize: 45,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 10,),
        Text(
          'Login / Signup',
          style: TextStyle(
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  Widget loginButton(BuildContext context, VoidCallback onPressedFunctions) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.grey.shade100)
          ),
          elevation: 2
        ),
        onPressed: () async{
          onPressedFunctions();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://cdn1.iconfinder.com/data/icons/google-s-logo/150/Google_Icons-09-512.png',
              width: 30,
            ),
            const SizedBox(width: 10,),
            const Text(
              'Continue using Google',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15
              ),
            )
          ],
        ),
      ),
    );
  }

}
