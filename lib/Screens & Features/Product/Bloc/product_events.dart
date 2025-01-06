abstract class ProductEvents {}

class InitializeProductPage extends ProductEvents {
  final String productId;

  InitializeProductPage({required this.productId});
}

class UpdateFavCats extends ProductEvents {
  final String productId;

  UpdateFavCats({required this.productId});
}

class LoadProductEvent extends ProductEvents {
  final String productId;

  LoadProductEvent(this.productId);
}

class AddToCartEvent extends ProductEvents {
  final String productId;
  final int quantity;
  final String size;
  final String variant;

  AddToCartEvent({
    required this.productId,
    required this.quantity,
    required this.size,
    required this.variant,
  });
}

class BuyNowEvent extends ProductEvents {
  final String productId;
  final int quantity;
  final String size;
  final String variant;

  BuyNowEvent({
    required this.productId,
    required this.quantity,
    required this.size,
    required this.variant,
  });
}

class UpdateProductID extends ProductEvents {
  final String productId;

  UpdateProductID(this.productId);
}

class UpdateVariationDocID extends ProductEvents {
  final String variationDocID;

  UpdateVariationDocID(this.variationDocID);
}

class UpdateImageSliderDocID extends ProductEvents {
  final String imageSliderDocID;

  UpdateImageSliderDocID(this.imageSliderDocID);
}

class UpdateQuantity extends ProductEvents {
  final int quantity;

  UpdateQuantity(this.quantity);
}

class UpdateVariationCount extends ProductEvents {
  final int variationCount;

  UpdateVariationCount(this.variationCount);
}

class UpdateClickedIndex extends ProductEvents {
  final int clickedIndex;

  UpdateClickedIndex(this.clickedIndex);
}

class UpdateSizes extends ProductEvents {
  final List<String> sizes;

  UpdateSizes(this.sizes);
}

class UpdateDiscountCal extends ProductEvents {
  final double discountCal;

  UpdateDiscountCal(this.discountCal);
}

class UpdateSizeSelected extends ProductEvents {
  final int sizeSelected;

  UpdateSizeSelected(this.sizeSelected);
}

class UpdateVariationSelected extends ProductEvents {
  final int variantionSelected;

  UpdateVariationSelected(this.variantionSelected);
}

class UpdateVariationWarning extends ProductEvents {
  final bool variationWarning;

  UpdateVariationWarning(this.variationWarning);
}

class UpdateSizeWarning extends ProductEvents {
  final bool sizeWarning;

  UpdateSizeWarning(this.sizeWarning);
}

