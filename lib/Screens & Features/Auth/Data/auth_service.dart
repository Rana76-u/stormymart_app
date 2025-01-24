// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';

// Project imports:
import 'package:stormymart_v2/Screens%20&%20Features/Search/Presentation/search.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Cart/Presentation/cart_loginpage.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    //clientId: const String.fromEnvironment('608528534677-lss1vqesvvhjos94ijukha2pnrj3e3ft.apps.googleusercontent.com')//newly added for web
    //Don't know why but "clientId" is not needed
  );
  //Previous => 608528534677-9k5dmi7ceihfoph33b4md35khifobfjg.apps.googleusercontent.com

  Future<User?> signInWithGoogle() async{
    final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleSignInAccount!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final User? user = (await _auth.signInWithCredential(credential)).user;
    return user;
  }


  void signOut() {
    final box = Hive.box('userInfo');
    box.deleteFromDisk();

    _auth.signOut();
    _googleSignIn.signOut();
    //FirebaseAuth.instance.signOut();
  }
  handleAuthState() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapShot) {
        if (snapShot.hasData) {
          return SearchPage(); // Modify  1 to 0 (Do it later)
        } else {
          return const CartLoginPage();
        }
      },
    );
  }
}
