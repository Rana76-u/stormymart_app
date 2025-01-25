// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:stormymart_v2/Screens%20&%20Features/Product/Bloc/product_events.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Product/Bloc/product_states.dart';
import '../../User/Data/user_hive.dart';

class ProductBloc extends Bloc<ProductEvents, ProductState>{
  ProductBloc() : super(ProductState(
      productID: '',
      variationDocID: '',
      imageSliderDocID: '',
      quantity: 1,
      variationCount: 0,
      clickedIndex: 0,
      sizes: [],
      discountCal: 0,
      sizeSelected: -1,
      variationSelected: -1,
      variationWarning: false,
      sizeWarning: false,
      scrollController: ScrollController()
  )) {
    on<InitializeProductPage>(_onInitializeProductPage);
    on<UpdateFavCats>(_onUpdateFavCats);
    on<ProductEvents>((event, emit) {
      ProductState newState = state;

      if(event is UpdateProductID){
        newState = _updateProductID(newState, event);
      }
      else if(event is UpdateVariationDocID){
        newState = _updateVariationDocID(newState, event);
      }
      else if(event is UpdateImageSliderDocID){
        newState = _updateImageSliderDocID(newState, event);
      }
      else if(event is UpdateQuantity){
        newState = _updateQuantity(newState, event);
      }
      else if(event is UpdateVariationCount){
        newState = _updateVariationCount(newState, event);
      }
      else if(event is UpdateClickedIndex){
        newState = _updateClickedIndex(newState, event);
      }
      else if(event is UpdateSizes){
        newState = _updateSizes(newState, event);
      }
      else if(event is UpdateDiscountCal){
        newState = _updateDiscountCal(newState, event);
      }
      else if(event is UpdateSizeSelected){
        newState = _updateSizeSelected(newState, event);
      }
      else if(event is UpdateVariationSelected){
        newState = _updateVariationSelected(newState, event);
      }
      else if(event is UpdateVariationWarning){
        newState = _updateVariationWarning(newState, event);
      }
      else if(event is UpdateSizeWarning){
        newState = _updateSizeWarning(newState, event);
      }

      emit(newState);
    });
  }


  Future<void> _onInitializeProductPage(InitializeProductPage event, Emitter<ProductState> emit) async {
    try {
      // Perform checkLength logic
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('/Products/${event.productId}/Variations')
          .get();

      final variationCount = snapshot.docs.length;
      final imageSliderDocID = snapshot.docs.first.id;

      emit(state.copyWith(
        productID: event.productId,
        variationCount: variationCount,
        imageSliderDocID: imageSliderDocID,
      ));
    } catch (e) {
      if (kDebugMode) {
        print('Error in InitializeProductPage: $e');
      }
    }
  }

  Future<void> _onUpdateFavCats(UpdateFavCats event, Emitter<ProductState> emit) async {
    try {
      // Fetch the product document
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Products')
          .doc(event.productId)
          .get();

      // Get the keywords list from the product document
      List<dynamic> category = snapshot.get('keywords');

      // Fetch the user's FavCats map
      DocumentReference userDoc = FirebaseFirestore.instance
          .collection('userData')
          .doc(UserHive().getUserUid());

      DocumentSnapshot userSnapshot = await userDoc.get();
      Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;

      Map<String, dynamic> favCats;

      if (userData.containsKey('FavCats')) {
        // 'FavCats' field exists
        print("FavCats exists: ${userData['FavCats']}");
        favCats = userSnapshot.get('FavCats');
      } else {
        // 'FavCats' field does not exist
        print("FavCats does not exist.");
        // Add the 'FavCats' field to the document
        await userDoc.set({
          'FavCats': {} // Initialize with an empty map
        }, SetOptions(merge: true));

        favCats = {};
      }

      //Map<String, dynamic> favCats = userSnapshot.get('FavCats') ?? {};

      // Update the FavCats map
      for (String keyword in category) {
        if (favCats.containsKey(keyword)) {
          favCats[keyword] += 1; // Increment the count
        } else {
          favCats[keyword] = 1; // Add new keyword with a count of 1
        }
      }

      // Save the updated map back to Firestore
      //await userDoc.update({'FavCats': favCats});
      await userDoc.set({'FavCats': favCats}, SetOptions(merge: true));
    } catch (e) {
      if (kDebugMode) {
        print('Error updating FavCats: $e');
      }
    }
  }



  ProductState _updateProductID(ProductState currentState, UpdateProductID event) {
    return currentState.copyWith(productID: event.productId);
  }

  ProductState _updateVariationDocID(ProductState currentState, UpdateVariationDocID event) {
    return currentState.copyWith(variationDocID: event.variationDocID);
  }

  ProductState _updateImageSliderDocID(ProductState currentState, UpdateImageSliderDocID event) {
    return currentState.copyWith(imageSliderDocID: event.imageSliderDocID);
  }

  ProductState _updateQuantity(ProductState currentState, UpdateQuantity event) {
    return currentState.copyWith(quantity: event.quantity);
  }

  ProductState _updateVariationCount(ProductState currentState, UpdateVariationCount event) {
    return currentState.copyWith(variationCount: event.variationCount);
  }

  ProductState _updateClickedIndex(ProductState currentState, UpdateClickedIndex event) {
    return currentState.copyWith(clickedIndex: event.clickedIndex);
  }

  ProductState _updateSizes(ProductState currentState, UpdateSizes event) {
    return currentState.copyWith(sizes: event.sizes);
  }

  ProductState _updateDiscountCal(ProductState currentState, UpdateDiscountCal event) {
    return currentState.copyWith(discountCal: event.discountCal);
  }

  ProductState _updateSizeSelected(ProductState currentState, UpdateSizeSelected event) {
    return currentState.copyWith(sizeSelected: event.sizeSelected);
  }

  ProductState _updateVariationSelected(ProductState currentState, UpdateVariationSelected event) {
    return currentState.copyWith(variationSelected: event.variantionSelected);
  }

  ProductState _updateVariationWarning(ProductState currentState, UpdateVariationWarning event) {
    return currentState.copyWith(variationWarning: event.variationWarning);
  }

  ProductState _updateSizeWarning(ProductState currentState, UpdateSizeWarning event) {
    return currentState.copyWith(sizeWarning: event.sizeWarning);
  }
}
