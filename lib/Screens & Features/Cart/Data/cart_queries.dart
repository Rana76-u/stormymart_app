import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartQueries {

  Future<QuerySnapshot<Map<String, dynamic>>> getCartItems() {
    return FirebaseFirestore.instance
        .collection('userData')
        .doc(FirebaseAuth.instance.currentUser!.uid)
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