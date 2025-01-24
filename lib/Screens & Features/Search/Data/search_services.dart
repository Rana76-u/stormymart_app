
import 'package:cloud_firestore/cloud_firestore.dart';
///todo:
/*
class SearchServices {

  void performSearch(String searchItem, {double? minPrice, double? maxPrice, double? minRating}) async {
    // Get a reference to the products collection
    var ref = FirebaseFirestore.instance.collection('/Products');
    // Convert the search query to uppercase
    searchItem = searchItem.toUpperCase();
    // Build a query for title filtering
    var titleQuery = ref.where('title', isGreaterThanOrEqualTo: searchItem);

    var titleSnapshot = await titleQuery.get();
    var titleDocs = titleSnapshot.docs;

    // Apply price and rating filtering on the title filtered documents
    var filteredDocs = titleDocs.where((doc) {
      var data = doc.data();
      var price = data['price'].toDouble();
      var rating = data['rating'].toDouble();
      return (minPrice == null || price >= minPrice) &&
          (maxPrice == null || price <= maxPrice) &&
          (minRating == null || rating >= minRating);
    }).toList();

    // Update the search results
    setState(() {
      _searchResults = filteredDocs;
      _isSearching = false;
    });
  }

  // Function to filter the products based on selected option
  void filterProductsByKeyword({double? minPrice, double? maxPrice, double? minRating}) async {
    setState(() {
      _isSearching = true;
    });
    // Filter the Firestore collection by 'keywords' field
    var keywordQuery = FirebaseFirestore.instance
        .collection('/Products')
        .where('keywords', arrayContains: widget.keyword?.toLowerCase());

    var keywordSnapshot = await keywordQuery.get();
    var keywordDocs = keywordSnapshot.docs;

    var filteredDocs = keywordDocs.where((doc) {
      var data = doc.data();
      var price = data['price'].toDouble();
      var rating = data['rating'].toDouble();
      return (minPrice == null || price >= minPrice) &&
          (maxPrice == null || price <= maxPrice) &&
          (minRating == null || rating >= minRating);
    }).toList();

    setState(() {
      _searchResults = filteredDocs;
      _isSearching = false;
    });
  }

}*/
