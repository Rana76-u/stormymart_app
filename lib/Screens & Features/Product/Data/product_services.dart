import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  Future<QuerySnapshot<Map<String, dynamic>>> getPopularProducts() {
    return FirebaseFirestore.instance
        .collection('/Products')
        .orderBy('sold', descending: true).limit(10)
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getHotDeals() {
    return FirebaseFirestore.instance
        .collection('/Products')
        .where('keywords', arrayContains: 'hotDeals').limit(10)
        .get();
  }
}