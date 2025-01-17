// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../Home/Bloc/home_bloc.dart';
import '../Home/Bloc/home_event.dart';

class SearchbarWidget extends StatefulWidget {
  const SearchbarWidget({super.key});

  @override
  State<SearchbarWidget> createState() => _SearchbarWidgetState();
}

class _SearchbarWidgetState extends State<SearchbarWidget> {

  // Create a text controller and reference it
  final TextEditingController _searchController = TextEditingController();
  String searchedText = '';

  // A flag to determine if the search has completed
  bool _isSearching = false;
  bool isTyping = false;
  bool isFilterOpen = false;

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
      final provider = BlocProvider.of<HomeBloc>(context);
      provider.add(UpdateSearchResults(searchResults: filteredDocs));
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      padding: const EdgeInsets.only(left: 20, right: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            searchedText = value;
            isTyping = true;
            isFilterOpen = false;
          });
          performSearch(value);
        },
        onSubmitted: (value) {
          setState(() {
            _isSearching = true;
            isTyping = false;
          });
          performSearch(value);
        },
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
          hintText: "Search",
          hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
          suffixIcon: GestureDetector(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.search_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

}

