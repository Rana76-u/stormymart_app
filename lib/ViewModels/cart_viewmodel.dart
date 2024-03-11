import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CartViewModel {

  Future<void> deleteDocument(
      BuildContext context,
      String cartItemDocID,
      double? price,
      int index
      ) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    try {
      await FirebaseFirestore.instance
          .collection(
          '/userData/$uid/Cart')
          .doc(cartItemDocID)
          .delete();
    } catch (error) {
      const Text('Error Deleting Cart Item');
    } finally {

    }
  }

  Future<bool> checkIfCartItemExists(String cartItemId) async {
    String documentId = 'sdfjkldsfhjisdfkjhh';
    CollectionReference productsCollection = FirebaseFirestore.instance.collection('Products');

    try {
      DocumentSnapshot<Object?> querySnapshot = await productsCollection.doc(documentId).get();
      if (querySnapshot.exists) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error checking document existence: $e');
      }
      return false;
    }
  }

}