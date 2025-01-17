// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Project imports:
import '../../User/Data/user_hive.dart';

class CartQueries {

  Future<QuerySnapshot<Map<String, dynamic>>> getCartItems() {
    return FirebaseFirestore.instance
        .collection('userData')
        .doc(UserHive().getUserUid())
        .collection('Cart')
        .orderBy('id')
        .get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> loadProduct(String productId) {
    return FirebaseFirestore.instance
        .collection('/Products')
        .doc(productId.trim())
        .get();
  }

}
