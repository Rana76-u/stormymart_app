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
  )) {
    on<CheckOutEvents>((event, emit) async {
      CheckOutState newState = state;

      if (event is TransferDataEvent) {
      newState = _transferData(newState, event);
      }
      else if (event is LoadUserDataEvent) {
        newState = await _loadUserData(newState, event);
      }
      else if(event is ChangeDivisionEvent){
        newState = _changeDivision(newState, event);
      }

      emit(newState);
    });
  }

  CheckOutState _transferData(CheckOutState currentState, TransferDataEvent event) {
    // Assuming CartState and CheckOutState have similar structure
    // Modify this according to your actual implementation
    return currentState.copyWith(
      idList: event.cartState.idList,
      priceList: event.cartState.priceList,
      sizeList: event.cartState.sizeList,
      variantList: event.cartState.variantList,
      quantityList: event.cartState.quantityList,
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
      selectedDivision: snapshot.get('Address1')[1]
    );
  }

  CheckOutState _changeDivision(CheckOutState state, ChangeDivisionEvent event) {
    return state.copyWith(
      selectedDivision: event.selectedDivision
    );
  }
}

