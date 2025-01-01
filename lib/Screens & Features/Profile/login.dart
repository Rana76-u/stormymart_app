import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stormymart_v2/Screens & Features/Profile/profile.dart';
import '../Auth/auth_service.dart';

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
                            GoRouter.of(context).go('/profile');
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
