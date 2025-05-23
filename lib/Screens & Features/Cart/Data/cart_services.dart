// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

// Project imports:
import '../../User/Data/user_hive.dart';
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
    final uid = UserHive().getUserUid();

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

  //total with discount and delivery charge
  num getTotal(CartState cartState) {
    num priceAfterDiscount = CartServices().calculateDiscountedPrice(
        CartServices().getCartSelectedItemTotal(cartState), 5
    );

    return priceAfterDiscount + 120;
  }

  double calculateDiscountedPrice(num price, num discount) {
    return price * (1 - discount / 100);
  }

  bool getCheckBoxValueForIndividual(CartState state, int index) {
    return state.checkList.isNotEmpty
        ? state.checkList[index]
        : false;
  }

}
