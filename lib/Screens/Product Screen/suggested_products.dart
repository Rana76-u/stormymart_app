import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Product Card/product_card_widget.dart';

Widget suggestedProducts(String thisProductID) {
  Future<List<QueryDocumentSnapshot>> getRelevantProducts() async {
    try {
      // Step 1: Fetch FavCats
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('userData')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      Map<String, dynamic> favCats = userSnapshot.get('FavCats') ?? {};

      if (favCats.isEmpty) {
        print('FavCats is empty.');
        return [];
      }

      // Step 2: Sort categories by frequency
      List<String> sortedCategories = favCats.keys.toList()
        ..sort((a, b) => favCats[b].compareTo(favCats[a])); // Descending order

      // Step 3: Query Products
      List<QueryDocumentSnapshot> relevantProducts = [];
      for (String category in sortedCategories) {
        if (relevantProducts.length >= 10) {
          break; // Stop if we already have 10 products
        }

        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('Products')
            .where('keywords', arrayContains: category)
            .limit(
                10 - relevantProducts.length) // Get only the remaining products
            .get();

        relevantProducts.addAll(querySnapshot.docs);
      }

      return relevantProducts;
    } catch (e) {
      print('Error fetching relevant products: $e');
      return [];
    }
  }

  List itemRepetitionChecker = [];

  return FutureBuilder<List<QueryDocumentSnapshot>>(
    future: getRelevantProducts(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      else if (snapshot.hasError) {
        return const Center(child: Text('Error fetching products'));
      }
      else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Center(child: Text('No relevant products found.'));
      }

      final products = snapshot.data!;

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 465,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index].data() as Map<String, dynamic>;

              double priceAfterDiscount =
                  (product['price'] / 100) *
                      (100 - product['discount']);

              if(itemRepetitionChecker.contains(products[index].id) || products[index].id == thisProductID){
                return const SizedBox();
              }
              else{
                itemRepetitionChecker.add(products[index].id);

                return productCard(context, products[index].id, product['discount'], priceAfterDiscount, product['title'], product['sold']);
              }

            },
          ),
        ),
      );
    },
  );
}
