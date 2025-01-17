// Package imports:
import 'package:hive/hive.dart';

// Project imports:
import 'package:stormymart_v2/Screens%20&%20Features/User/Data/user_hive.dart';

class UserServices {

  bool isUserLoggedIn(){
    //check if box is open and uid field is there
    if(Hive.box('userInfo').containsKey('userUid')){
      //then check is the field is empty or not
      if(UserHive().getUserUid() != ''){
        return true;
      }
      else{
        return false;
      }
    }
    else{
      return false;
    }

  }

}
