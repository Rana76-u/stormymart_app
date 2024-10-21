class HomeState {
  final String profileName;
  final String profileImageUrl;
  final int cartValue;

  HomeState({
    required this.profileName,
    required this.profileImageUrl,
    required this.cartValue,
  });

  HomeState copyWith({
    String? profileName,
    String? profileImageUrl,
    int? cartValue,
  }) {
    return HomeState(
      profileName: profileName ?? this.profileName,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      cartValue: cartValue ?? this.cartValue,
    );
  }
}