import 'package:flutter/material.dart';
import 'package:stormymart_v2/Screens/Profile/profile.dart';
import '../../utility/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).size.width >= 600 ?
      EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.3) :
      const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Expanded(child: SizedBox()),

          /*Lottie.asset(
              'assets/lottie/google-logo.json',
            height: MediaQuery.of(context).size.height*0.4
          ),*/

          Row(
            children: [
              const Expanded(child: SizedBox()),
              Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.login_rounded,
                        size: 50,
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Container(
                          width: 2, // Adjust the width according to your requirement
                          height: 40, // Adjust the height according to your requirement
                          color: Colors.black,
                        ),
                      ),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 3),
                            child: Text(
                              'StormyMart',
                              style: TextStyle(
                                fontSize: 25,
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 3),
                            child: Text(
                              'Login / Signup',
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 25,),

                  //Login Button
                  isLoading ? const LinearProgressIndicator():
                  SizedBox(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                        ),
                      ),
                      onPressed: () async{
                        setState(() {
                          isLoading = true;
                        });

                        //await Authservice().signInWithGoogle();
                        AuthService().signInWithGoogle().then((_) {
                          setState(() {
                            isLoading = false;
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const Profile(),
                            ));
                          });
                        })
                            .catchError((error) {
                          // Handle any error that occurred during sign-in
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Error: $error')
                              )
                          );

                          debugPrint('Error: $error');

                          setState(() {
                            isLoading = false;
                          });
                        });
                      },
                      child: const Text(
                        'Continue using Google',
                        style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.bold,
                            fontSize: 13
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}
