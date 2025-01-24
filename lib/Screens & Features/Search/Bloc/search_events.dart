import 'package:cloud_firestore/cloud_firestore.dart';

abstract class SearchEvent {}

class UpdateMinPrice extends SearchEvent {
  final double minPrice;

  UpdateMinPrice(this.minPrice);
}

class UpdateMaxPrice extends SearchEvent {
  final double maxPrice;

  UpdateMaxPrice(this.maxPrice);
}

class UpdateSelectedMinPrice extends SearchEvent {
  final double selectedMinPrice;

  UpdateSelectedMinPrice(this.selectedMinPrice);
}

class UpdateSelectedMaxPrice extends SearchEvent {
  final double selectedMaxPrice;

  UpdateSelectedMaxPrice(this.selectedMaxPrice);
}

class UpdateSearchedText extends SearchEvent {
  final String searchedText;

  UpdateSearchedText(this.searchedText);
}

class UpdateIsSearching extends SearchEvent {
  final bool isSearching;

  UpdateIsSearching(this.isSearching);
}

class UpdateIsTyping extends SearchEvent {
  final bool isTyping;

  UpdateIsTyping(this.isTyping);
}

class UpdateIsFilterOpen extends SearchEvent {
  final bool isFilterOpen;

  UpdateIsFilterOpen(this.isFilterOpen);
}

class UpdateSearchResults extends SearchEvent {
  final List<DocumentSnapshot> searchResults;

  UpdateSearchResults(this.searchResults);
}