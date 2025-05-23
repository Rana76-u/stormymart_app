// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'cart_events.dart';
import 'cart_states.dart';

class CartBloc extends Bloc<CartEvents, CartState> {
  CartBloc() : super(CartState(
    idList: [],
    priceList: [],
    sizeList: [],
    variantList: [],
    quantityList: [],
    checkList: [],
    total: 0,
    isAllSelected: false,
  )) {

    on<CartEvents>((event, emit) {
      CartState newState = state; // Initialize newState with current state

      if(event is AddItemEvent){
        newState = _addItem(newState, event);
      }
      else if(event is UpdateCheckList){
        newState = _updateCheckList(newState, event);
      }
      else if(event is UpdateQuantityList){
        newState = _updateQuantityList(newState, event);
      }
      else if(event is DeleteItemEvent){
        newState = _deleteItem(newState, event.index);
      }
      else if(event is SelectAllCheckList){
        newState = _selectAllCheckList(newState, event);
      }

      emit(newState); // Emit the new state after handling the event
    });
  }

  CartState _addItem(CartState currentState, AddItemEvent event) {

    // Update lists with new item details
    List<String> updatedIdList = List.from(currentState.idList)..add(event.id);
    List<double> updatedPriceList = List.from(currentState.priceList)..add(event.price);
    List<String> updatedSizeList = List.from(currentState.sizeList)..add(event.size);
    List<String> updatedVariantList = List.from(currentState.variantList)..add(event.variant);
    List<int> updatedQuantityList = List.from(currentState.quantityList)..add(event.quantity);
    List<bool> updatedCheckList = List.from(currentState.checkList)..add(true);

    // Return the updated state
    return currentState.copyWith(
      idList: updatedIdList,
      priceList: updatedPriceList,
      sizeList: updatedSizeList,
      variantList: updatedVariantList,
      quantityList: updatedQuantityList,
      checkList: updatedCheckList
    );
  }

  CartState _updateCheckList(CartState currentState, UpdateCheckList event) {
    // Check if index is valid
    if (event.index < 0 || event.index >= currentState.idList.length) {
      throw ArgumentError('Index out of range');
    }

    // Update lists by removing item at the given index
    List<double> priceList = List.from(currentState.priceList);
    List<bool> updatedCheckList = List.from(currentState.checkList);
    List<int> quantityList = List.from(currentState.quantityList);
    updatedCheckList[event.index] = event.isChecked;

    //update total amount
    double updatedTotal = 0;
    for(int i=0; i<priceList.length; i++){
      if(updatedCheckList[i] == true){
        updatedTotal = updatedTotal + (priceList[i] * quantityList[i]);
      }
    }

    // Check if all items in updatedCheckList are true
    bool isAllSelected = updatedCheckList.every((element) => element);

    // Return the updated state
    return currentState.copyWith(
        checkList: updatedCheckList,
        isAllSelected: isAllSelected,
        total: updatedTotal
    );
  }

  CartState _updateQuantityList(CartState currentState, UpdateQuantityList event) {
    // Check if index is valid
    if (event.index < 0 || event.index >= currentState.idList.length) {
      throw ArgumentError('Index out of range');
    }

    // Update lists by removing item at the given index
    List<double> priceList = List.from(currentState.priceList);
    List<bool> checkList = List.from(currentState.checkList);
    List<int> updatedQuantityList = List.from(currentState.quantityList);
    updatedQuantityList[event.index] = event.quantity;

    //update total amount
    double updatedTotal = 0;
    for(int i=0; i<priceList.length; i++){
      if(checkList[i] == true){
        updatedTotal = updatedTotal + (priceList[i] * updatedQuantityList[i]);
      }
    }

    // Return the updated state
    return currentState.copyWith(
        quantityList: updatedQuantityList,
        total: updatedTotal
    );
  }

  CartState _selectAllCheckList(CartState state, SelectAllCheckList event) {

    List<double> priceList = List.from(state.priceList);
    List<bool> updatedCheckList = List<bool>.filled(state.checkList.length, event.isSelectAll);
    List<int> quantityList = List.from(state.quantityList);

    double updatedTotal = 0;
    if(event.isSelectAll){
      for(int i=0; i<priceList.length; i++){
        if(updatedCheckList[i] == true){
          updatedTotal += (priceList[i] * quantityList[i]);
        }
      }
    }

    return state.copyWith(
        checkList: updatedCheckList,
        total: updatedTotal,
        isAllSelected: event.isSelectAll
    );
  }

  CartState _deleteItem(CartState currentState, int index) {
    // Check if index is valid
    if (index < 0 || index >= currentState.idList.length) {
      throw ArgumentError('Index out of range');
    }

    // Update lists by removing item at the given index
    List<String> updatedIdList = List.from(currentState.idList)..removeAt(index);
    List<double> updatedPriceList = List.from(currentState.priceList)..removeAt(index);
    List<String> updatedSizeList = List.from(currentState.sizeList)..removeAt(index);
    List<String> updatedVariantList = List.from(currentState.variantList)..removeAt(index);
    List<int> updatedQuantityList = List.from(currentState.quantityList)..removeAt(index);
    List<bool> updatedCheckList = List.from(currentState.checkList)..removeAt(index);

    //update total amount
    double updatedTotal = 0;
    for(int i=0; i<updatedPriceList.length; i++){
      if(updatedCheckList[i] == true){
        updatedTotal += (updatedPriceList[i] * updatedQuantityList[i]);
      }
    }

    // Return the updated state
    return currentState.copyWith(
      idList: updatedIdList,
      priceList: updatedPriceList,
      sizeList: updatedSizeList,
      variantList: updatedVariantList,
      quantityList: updatedQuantityList,
      checkList: updatedCheckList,
      total: updatedTotal
    );
  }
}


