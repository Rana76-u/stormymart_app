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
    );
  }
}
