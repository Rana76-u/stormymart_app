
import 'package:firebase_auth/firebase_auth.dart';

class UserServices {

  bool isUserLoggedIn(){
    if(FirebaseAuth.instance.currentUser != null){
      return true;
    }
    else{
      return false;
    }
  }

}