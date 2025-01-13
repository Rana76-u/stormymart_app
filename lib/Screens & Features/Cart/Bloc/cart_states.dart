class CartState {
  List<String> idList;
  List<double> priceList;
  List<String> sizeList;
  List<String> variantList;
  List<int> quantityList;
  List<bool> checkList;
  double total;
  bool isAllSelected;

  CartState({
    required this.idList,
    required this.priceList,
    required this.sizeList,
    required this.variantList,
    required this.quantityList,
    required this.checkList,
    required this.total,
    required this.isAllSelected,
  });

  CartState copyWith({
    List<String>? idList,
    List<double>? priceList,
    List<String>? sizeList,
    List<String>? variantList,
    List<int>? quantityList,
    List<bool>? checkList,
    double? total,
    bool? isAllSelected,
  }) {
    return CartState(
      idList: idList ?? this.idList,
      priceList: priceList ?? this.priceList,
      sizeList: sizeList ?? this.sizeList,
      variantList: variantList ?? this.variantList,
      quantityList: quantityList ?? this.quantityList,
      checkList: checkList ?? this.checkList,
      total: total ?? this.total,
      isAllSelected: isAllSelected ?? this.isAllSelected,
    );
  }
}
