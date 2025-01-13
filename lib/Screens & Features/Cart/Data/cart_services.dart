import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../Bloc/cart_states.dart';

class CartServices {

  double total = 0;

  Future<bool> checkIfCartItemExists(String productId) async {
    String productDocId = productId; //'sdfjkldsfhjisdfkjhh'
    CollectionReference productsCollection = FirebaseFirestore.instance.collection('Products');

    try {
      DocumentSnapshot<Object?> querySnapshot = await productsCollection.doc(productDocId).get();
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

  double getCartSelectedItemTotal(CartState state) {
    for (int i = 0; i < state.idList.length; i++) {
      if (state.checkList[i] == true) {
        total += state.priceList[i] * state.quantityList[i];
      }
    }
    return total;
  }

  void setTotal(double total){
    this.total = total;
  }

  double calculateDiscountedPrice(num price, num discount) {
    return price * (1 - discount / 100);
  }

}