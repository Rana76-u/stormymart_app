// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchStates {
  double minPrice;
  double maxPrice;
  double selectedMinPrice;
  double selectedMaxPrice;
  String searchedText;

  bool isSearching;
  bool isTyping;
  bool isFilterOpen;

  // A list to hold the search results
  List<DocumentSnapshot> searchResults;
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  SearchStates({
    required this.minPrice,
    required this.maxPrice,
    required this.selectedMinPrice,
    required this.selectedMaxPrice,
    required this.searchedText,
    required this.isSearching,
    required this.isTyping,
    required this.isFilterOpen,
    required this.searchResults,
});

  SearchStates copyWith({
    double? minPrice,
    double? maxPrice,
    double? selectedMinPrice,
    double? selectedMaxPrice,
    String? searchedText,
    bool? isSearching,
    bool? isTyping,
    bool? isFilterOpen,
    List<DocumentSnapshot>? searchResults,

}) {
    return SearchStates(
        minPrice: minPrice ?? this.minPrice,
        maxPrice: maxPrice ?? this.maxPrice,
        selectedMinPrice: selectedMinPrice ?? this.selectedMinPrice,
        selectedMaxPrice: selectedMaxPrice ?? this.selectedMaxPrice,
        searchedText: searchedText ?? this.searchedText,
        isSearching: isSearching ?? this.isSearching,
        isTyping: isTyping ?? this.isTyping,
        isFilterOpen: isFilterOpen ?? this.isFilterOpen,
        searchResults: searchResults ?? this.searchResults
    );
}

}
