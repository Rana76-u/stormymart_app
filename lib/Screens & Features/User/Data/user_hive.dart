// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

class UserHive {
  final box = Hive.box('userInfo');

  setUserName(String name){
    box.put('userName', name);
  }

  String getUserName(){
    return box.get('userName');
  }


  void setUserEmail(String email) {
    box.put('userEmail', email);
  }

  String getUserEmail() {
    return box.get('userEmail', defaultValue: '');
  }


  void setUserUid(String uid) {
    box.put('userUid', uid);
  }

  String getUserUid() {
    return box.get('userUid', defaultValue: '');
  }


  void setUserPhoneNumber(String phoneNumber) {
    box.put('userPhoneNumber', phoneNumber);
  }

  String getUserPhoneNumber() {
    return box.get('userPhoneNumber', defaultValue: '');
  }


  void setUserPhotoURL(String photoURL) {
    box.put('userPhotoURL', photoURL);
  }

  String getUserPhotoURL() {
    return box.get('userPhotoURL', defaultValue: '');
  }


  updateUserData() async {
    final userInstance = FirebaseAuth.instance.currentUser!;
    String name = userInstance.displayName ?? '';
    String email = userInstance.email ?? '';
    String uid = userInstance.uid;
    String phoneNumber = userInstance.phoneNumber ?? '';
    String photoURL = userInstance.photoURL ?? '';

    setUserName(name);
    setUserEmail(email);
    setUserUid(uid);
    setUserPhoneNumber(phoneNumber);
    setUserPhotoURL(photoURL);
  }

}
