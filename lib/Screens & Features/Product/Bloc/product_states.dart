
import 'package:flutter/cupertino.dart';

class ProductState{
  String productID;
  String variationDocID;
  String imageSliderDocID;
  int quantity;
  int variationCount;
  int clickedIndex;
  List<String> sizes;
  double discountCal;
  int sizeSelected;
  int variationSelected;
  bool variationWarning;
  bool sizeWarning;
  ScrollController scrollController;

  ProductState({
    required this.productID,
    required this.variationDocID,
    required this.imageSliderDocID,
    required this.quantity,
    required this.variationCount,
    required this.clickedIndex,
    required this.sizes,
    required this.discountCal,
    required this.sizeSelected,
    required this.variationSelected,
    required this.variationWarning,
    required this.sizeWarning,
    required this.scrollController,
  });

  ProductState copyWith({
    String? productID,
    String? variationDocID,
    String? imageSliderDocID,
    int? quantity,
    int? variationCount,
    int? clickedIndex,
    List<String>? sizes,
    double? discountCal,
    int? sizeSelected,
    int? variationSelected,
    bool? variationWarning,
    bool? sizeWarning,
    ScrollController? scrollController,
  }){
    return ProductState(
      productID: productID ?? this.productID,
      variationDocID: variationDocID ?? this.variationDocID,
      imageSliderDocID: imageSliderDocID ?? this.imageSliderDocID,
      quantity: quantity ?? this.quantity,
      variationCount: variationCount ?? this.variationCount,
      clickedIndex: clickedIndex ?? this.clickedIndex,
      sizes: sizes ?? this.sizes,
      discountCal: discountCal ?? this.discountCal,
      sizeSelected: sizeSelected ?? this.sizeSelected,
      variationSelected: variationSelected ?? this.variationSelected,
      variationWarning: variationWarning ?? this.variationWarning,
      sizeWarning: sizeWarning ?? this.sizeWarning,
      scrollController: scrollController ?? this.scrollController,
    );
  }
}