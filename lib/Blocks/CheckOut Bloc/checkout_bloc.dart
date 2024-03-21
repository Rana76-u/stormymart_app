import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stormymart_v2/Blocks/CheckOut%20Bloc/checkout_events.dart';
import 'package:stormymart_v2/Blocks/CheckOut%20Bloc/checkout_state.dart';

class CheckoutBloc extends Bloc<CheckOutEvents, CheckOutState> {
  CheckoutBloc()
      : super(CheckOutState(
    idList: [],
    priceList: [],
    sizeList: [],
    variantList: [],
    quantityList: [],

    userName: '',
    phoneNumber: '',
    selectedAddress: '',
    selectedDivision: '',

    isPromoCodeFound: true,
    promoDiscountAmount: 0,
    
    isUsingCoin: false,
    coinAmount: 0,

    itemTotal: 0,
    total: 0,

    isLoading: true
  )) {
    on<CheckOutEvents>((event, emit) async {
      CheckOutState newState = state;

      if (event is TransferDataEvent) {
      newState = _transferData(newState, event);
      }
      else if (event is LoadUserDataEvent) {
        newState = await _loadUserData(newState, event);
      }

      else if(event is ChangeUserInfoEvent){
        newState = _changeUserInfo(newState, event);
      }
      else if(event is ChangeDivisionEvent){
        newState = _changeDivision(newState, event);
      }

      else if (event is IsPromoCodeFound) {
        newState = _changeIsPromoCodeFound(state, event);
      }
      else if (event is UpdateIsUsingCoinEvent) {
        newState = _updateIsUsingCoinEvent(state, event);
      }

      else if (event is UpdateIsLoading) {
        newState = _updateIsLoading(state, event);
      }
      else if(event is UpdateTotal){
        newState = _changeTotal(state, event);
      }

      else if (event is ResetCheckoutEvent) {
        newState = CheckOutState(
          idList: [],
          priceList: [],
          sizeList: [],
          variantList: [],
          quantityList: [],
          userName: '',
          phoneNumber: '',
          selectedAddress: '',
          selectedDivision: '',
          isPromoCodeFound: true,
          promoDiscountAmount: 0,
          isUsingCoin: false,
          coinAmount: 0,
          itemTotal: 0,
          total: 0,
          isLoading: true
        );
      }

      emit(newState);
    });
  }

  CheckOutState _transferData(CheckOutState currentState, TransferDataEvent event) {
    // Extracting the checklist from the event
    List<bool> checkList = event.cartState.checkList;

    // Filtering data based on the checklist
    List<String> filteredIdList = [];
    List<double> filteredPriceList = [];
    List<String> filteredSizeList = [];
    List<String> filteredVariantList = [];
    List<int> filteredQuantityList = [];

    double total = 0;
    for (int i = 0; i < checkList.length; i++) {
      if (checkList[i]) {
        filteredIdList.add(event.cartState.idList[i]);
        filteredPriceList.add(event.cartState.priceList[i]);
        filteredSizeList.add(event.cartState.sizeList[i]);
        filteredVariantList.add(event.cartState.variantList[i]);
        filteredQuantityList.add(event.cartState.quantityList[i]);

        total = total + (event.cartState.priceList[i] * event.cartState.quantityList[i]);
      }
    }

    // Creating a new state with the filtered lists
    return currentState.copyWith(
      idList: filteredIdList,
      priceList: filteredPriceList,
      sizeList: filteredSizeList,
      variantList: filteredVariantList,
      quantityList: filteredQuantityList,
      itemTotal: total,
      total: total + 70
    );
  }

  Future<CheckOutState> _loadUserData(CheckOutState state, LoadUserDataEvent event) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('userData')
        .doc(event.uid)
        .get();

    return state.copyWith(
      userName: snapshot.get('name'),
      phoneNumber: snapshot.get('Phone Number'),
      selectedAddress: snapshot.get('Address1')[0],
      selectedDivision: snapshot.get('Address1')[1],
      coinAmount: snapshot.get('coins'),
      isLoading: false
    );
  }

  CheckOutState _changeUserInfo(CheckOutState state, ChangeUserInfoEvent event) {
    return state.copyWith(
      userName: event.name,
      phoneNumber: event.phoneNumber,
      selectedAddress: event.address
    );
  }
  CheckOutState _changeDivision(CheckOutState state, ChangeDivisionEvent event) {
    return state.copyWith(
      selectedDivision: event.selectedDivision
    );
  }

  CheckOutState _changeIsPromoCodeFound(CheckOutState state, IsPromoCodeFound event) {
    return state.copyWith(
        isPromoCodeFound: event.isPromoCodeFound,
      promoDiscountAmount: event.promoDiscountAmount
    );
  }

  CheckOutState _updateIsUsingCoinEvent(CheckOutState state, UpdateIsUsingCoinEvent event) {
    return state.copyWith(
        isUsingCoin: event.isUsingCoin
    );
  }

  CheckOutState _updateIsLoading(CheckOutState state, UpdateIsLoading event) {
    return state.copyWith(
        isLoading: event.isLoading
    );
  }


  CheckOutState _changeTotal(CheckOutState state, UpdateTotal event) {
    return state.copyWith(
        total: event.total
    );
  }
}

