import 'package:cloud_firestore/cloud_firestore.dart';

class HomeState {
  final String profileName;
  final String profileImageUrl;
  final int cartValue;
  final List<DocumentSnapshot> searchResults;

  HomeState({
    required this.profileName,
    required this.profileImageUrl,
    required this.cartValue,
    this.searchResults = const [],
  });

  HomeState copyWith({
    String? profileName,
    String? profileImageUrl,
    int? cartValue,
    List<DocumentSnapshot>? searchResults,
  }) {
    return HomeState(
      profileName: profileName ?? this.profileName,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      cartValue: cartValue ?? this.cartValue,
      searchResults: searchResults ?? this.searchResults,
    );
  }
}