// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

// Project imports:
import 'package:stormymart_v2/Screens%20&%20Features/Search/Bloc/search_states.dart';
import 'package:stormymart_v2/Screens%20&%20Features/User/Data/user_hive.dart';

class ProductQueries {

  Future<QuerySnapshot<Map<String, dynamic>>> getAllProducts() {
    return FirebaseFirestore.instance
        .collection('/Products')
        .get();
  }

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

  Future<QuerySnapshot<Map<String, dynamic>>> getSuggestedProducts() async {
    try {
      // Fetch FavCats
      DocumentSnapshot<Map<String, dynamic>> userSnapshot = await FirebaseFirestore.instance
          .collection('userData')
          .doc(UserHive().getUserUid())
          .get();

      Map<String, dynamic> favCats = userSnapshot.data()?['FavCats'] ?? {};

      if (favCats.isEmpty) {
        if (kDebugMode) {
          print('FavCats is empty.');
        }
        return FirebaseFirestore.instance.collection('Products').limit(10).get();
      }

      // Sort categories by frequency
      List<String> sortedCategories = favCats.keys.toList()
        ..sort((a, b) => favCats[b].compareTo(favCats[a])); // Descending order

      // Create a combined query
      Query<Map<String, dynamic>> query = FirebaseFirestore.instance.collection('Products');
      /*for (String category in sortedCategories) {
        query = query.where('keywords', arrayContains: category);
      }*/
      query = query.where('keywords', arrayContains: sortedCategories);

      query = query.orderBy('sold', descending: true).limit(10);
      return query.get();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching relevant products: $e');
      }
      throw Exception('Error fetching relevant products: $e');
    }
  }


  Future<QuerySnapshot<Map<String, dynamic>>> searchProductByTitle(SearchStates searchState) async {
    if(searchState.isFilterOpen){
      return FirebaseFirestore.instance
          .collection('/Products')
          .where(
          Filter.or(
              Filter('title', isGreaterThanOrEqualTo: searchState.searchedText),
              Filter('keywords', arrayContains: searchState.searchedText)
              /*Filter('price', isGreaterThanOrEqualTo: searchState.minPrice),
              Filter('price', isLessThanOrEqualTo: searchState.maxPrice)*/
          )
      )
      .where('price', isGreaterThanOrEqualTo: searchState.minPrice)
      .where('price', isLessThanOrEqualTo: searchState.maxPrice)
          .get();
    }
    else{
      return FirebaseFirestore.instance
          .collection('/Products')
          .where(
          Filter.or(
              Filter('title', isGreaterThanOrEqualTo: searchState.searchedText),
              Filter('keywords', arrayContains: searchState.searchedText)
          )
      ).get();

    }

  }


}
