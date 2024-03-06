import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stormymart_v2/utility/globalvariable.dart';
import 'cart_events.dart';
import 'cart_states.dart';

class CartBloc extends Bloc<CartEvents, CartState> {
  CartBloc() : super(CartState(
      checkList: [],
      priceList: [],
      idList: [],
      total: 0
  )) { //, isAllSelected: false

    on<CartEvents>((event, emit) {

      /*if(event is AddCheckList){
        final List<bool> updatedCheckList = List.from(state.checkList)..add(event.isChecked);
        final List<double> updatedPriceList = List.from(state.priceList)..add(event.price);
        final List<String> updatedCartItemDocIdList = List.from(state.cartItemDocIdList)..add(event.cartItemDocId);
        emit(CartState(
            checkList: updatedCheckList,
            priceList: updatedPriceList,
            cartItemDocIdList: updatedCartItemDocIdList,
            isAllSelected: state.isAllSelected
        )); //, isAllSelected: state.isAllSelected
      }

      else if(event is UpdateCheckList){
        final List<bool> updatedCheckList = List.from(state.checkList);
        updatedCheckList[event.index] = event.isChecked;

        final List<double> updatedPriceList = List.from(state.priceList);
        updatedPriceList[event.index] = event.price;

        final List<String> updatedCartItemDocIdList = List.from(state.cartItemDocIdList);
        updatedCartItemDocIdList[event.index] = event.cartItemDocId;

        emit(CartState(
            checkList: updatedCheckList,
            priceList: updatedPriceList,
            cartItemDocIdList: updatedCartItemDocIdList,
            isAllSelected: state.isAllSelected
        )); // ,isAllSelected: state.isAllSelected
      }

      */
      /*else if(event is SelectAllCheckList){
        final List<bool> updatedCheckList = List.from(state.checkList);
        for(int i=0; i<updatedCheckList.length; i++){
          updatedCheckList[i] = event.isSelectAll;
        }
        emit(CartState(checkList: updatedCheckList, isAllSelected: event.isSelectAll));
      }

      else if(event is UpdateIsSelected){
        emit(CartState(checkList: List.from(state.checkList), isAllSelected: event.isSelectAll)); // ,isAllSelected: state.isAllSelected
      }*/

      if(event is InitCheckListEvent){
        for(int i=0; i<event.numberOfItem; i++){
          state.checkList.add(false);
        }
      }

      else if(event is AddSelectedItemEvent){
        double total = 0;
        List<double> updatedPriceList = List.from(state.priceList);
        List<String> updatedIdList = List.from(state.idList);

        updatedPriceList.add(event.itemPrice);
        updatedIdList.add(event.itemId);

        for(int i=0; i<updatedPriceList.length; i++){
            total += updatedPriceList[i];
        }

        emit(CartState(
            checkList: state.checkList,
            priceList: updatedPriceList,
            idList: updatedIdList,
            total: total
        ));
      }
      else if(event is RemoveSelectedItemEvent){
        double total = 0;
        List<double> updatedPriceList = List.from(state.priceList);
        List<String> updatedIdList = List.from(state.idList);

        updatedPriceList.remove(event.itemPrice);
        updatedIdList.remove(event.itemId);

        for(int i=0; i<updatedPriceList.length; i++){
          total += updatedPriceList[i];
        }

        emit(CartState(
            checkList: state.checkList,
            priceList: updatedPriceList,
            idList: updatedIdList,
            total: total
        ));
      }

      else if(event is DeleteItemEvent){
        //remove from price, id and checklist list
        double total = 0;
        List<double> updatedPriceList = List.from(state.priceList);
        List<String> updatedIdList = List.from(state.idList);
        List<bool> updatedCheckList = List.from(state.checkList);

        if(event.price != null){
          updatedPriceList.removeAt(event.index);
        }
        updatedIdList.remove(event.id);
        updatedCheckList.removeAt(event.index);

        //re-calculate total
        for(int i=0; i<updatedPriceList.length; i++){
          total += updatedPriceList[i];
        }

        emit(CartState(
            checkList: updatedCheckList,
            priceList: updatedPriceList,
            idList: updatedIdList,
            total: total
        ));
      }
      else if(event is DeleteFromTempList){
        double total = 0;
        List<double> updatedPriceList = List.from(state.priceList);
        List<bool> updatedCheckList = List.from(state.checkList);

        //remove from price, id and checklist list
        tempProductIds.removeAt(event.index);
        tempQuantities.removeAt(event.index);
        tempVariants.removeAt(event.index);
        tempSizes.removeAt(event.index);
        updatedCheckList.removeAt(event.index);

        updatedPriceList.removeAt(event.index);

        //re-calculate total
        for(int i=0; i<updatedPriceList.length; i++){
          total += updatedPriceList[i];
        }

        emit(CartState(
            checkList: updatedCheckList,
            priceList: updatedPriceList,
            idList: tempProductIds,
            total: total
        ));
      }
    });
  }
}
