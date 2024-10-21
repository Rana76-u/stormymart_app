abstract class HomeEvents {}

class UpdateProfileEvent extends HomeEvents {
  final String name;
  final String imageUrl;

  UpdateProfileEvent({required this.name, required this.imageUrl});
}

class UpdateCartValueEvent extends HomeEvents {
  final int cartValue;

  UpdateCartValueEvent({required this.cartValue});
}