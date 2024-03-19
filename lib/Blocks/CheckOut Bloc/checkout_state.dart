class CheckOutState {
  List<String> idList;
  List<double> priceList;
  List<String> sizeList;
  List<String> variantList;
  List<int> quantityList;

  String userName;
  String phoneNumber;
  String selectedAddress;
  String selectedDivision;

  bool isPromoCodeFound;
  double promoDiscountAmount;

  bool isUsingCoin;
  double coinAmount;

  double itemTotal;
  double total;

  bool isLoading;

  CheckOutState({
    required this.idList,
    required this.priceList,
    required this.sizeList,
    required this.variantList,
    required this.quantityList,

    required this.userName,
    required this.phoneNumber,
    required this.selectedAddress,
    required this.selectedDivision,

    required this.isPromoCodeFound,
    required this.promoDiscountAmount,

    required this.isUsingCoin,
    required this.coinAmount,

    required this.itemTotal,
    required this.total,

    required this.isLoading
  });

  CheckOutState copyWith({
    List<String>? idList,
    List<double>? priceList,
    List<String>? sizeList,
    List<String>? variantList,
    List<int>? quantityList,

    String? userName,
    String? phoneNumber,
    String? selectedAddress,
    String? selectedDivision,

    bool? isPromoCodeFound,
    double? promoDiscountAmount,

    bool? isUsingCoin,
    double? coinAmount,

    double? itemTotal,
    double? total,

    bool? isLoading
  }) {
    return CheckOutState(
      idList: idList ?? this.idList,
      priceList: priceList ?? this.priceList,
      sizeList: sizeList ?? this.sizeList,
      variantList: variantList ?? this.variantList,
      quantityList: quantityList ?? this.quantityList,

      userName: userName ?? this.userName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      selectedDivision: selectedDivision ?? this.selectedDivision,

      isPromoCodeFound: isPromoCodeFound ?? this.isPromoCodeFound,
      promoDiscountAmount: promoDiscountAmount ?? this.promoDiscountAmount,

      isUsingCoin: isUsingCoin ?? this.isUsingCoin,
      coinAmount: coinAmount ?? this.coinAmount,

      itemTotal: itemTotal ?? this.itemTotal,
      total: total ?? this.total,

      isLoading: isLoading ?? this.isLoading,
    );
  }
}
