class CartState {
  List<bool> checkList;
  List<double> priceList;
  List<String> idList;
  double total;

  CartState({
    required this.checkList,
    required this.priceList,
    required this.idList,
    required this.total,
  });
}
