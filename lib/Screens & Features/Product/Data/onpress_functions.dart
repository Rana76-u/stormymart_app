// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Cart/Data/on_press_functions.dart';

// Project imports:
import 'package:stormymart_v2/Screens%20&%20Features/Product/Bloc/product_events.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Product/Bloc/product_states.dart';
import '../../Cart/Bloc/cart_bloc.dart';
import '../../Cart/Bloc/cart_events.dart';
import '../../Cart/Presentation/cart.dart';
import '../../User/Data/user_hive.dart';
import '../Bloc/product_bloc.dart';
import '../Presentation/product_screen.dart';

class OnPressFunctions {

  void viewProduct(BuildContext context, String productId) {
    final blocProvider = BlocProvider.of<ProductBloc>(context);
    blocProvider.add(UpdateProductID(productId));
    GoRouter.of(context).go('/product/$productId');
    /*Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => ProductScreen(productId: productId),)
    );*/
  }

  void addToCartFunction(String text, num quantityAvailable, String shopID, String id, BuildContext context, ProductState state) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final mediaQuery = MediaQuery.of(context);
    final productBloc = BlocProvider.of<ProductBloc>(context);
    final cartBloc = BlocProvider.of<CartBloc>(context);

    productBloc.add(UpdateSizeWarning(false));
    productBloc.add(UpdateVariationWarning(false));

    if (quantityAvailable == 0) {
      messenger
          .showSnackBar(const SnackBar(content: Text('Product Got Sold Out')));
    } else if (state.quantity > quantityAvailable) {
      messenger.showSnackBar(
          SnackBar(content: Text("Only $quantityAvailable items available")));
    } else {
      if (state.sizeSelected == -1 && state.sizes.isNotEmpty) {

        productBloc.add(UpdateSizeWarning(true));

        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Select Size')));
      }
      else if (state.variationSelected == -1) {

        productBloc.add(UpdateVariationWarning(true));

        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Select Variant')));
      }
      else {
        //user logged in
        if (FirebaseAuth.instance.currentUser != null) {
          String uid = UserHive().getUserUid();

          await FirebaseFirestore.instance
              .collection('userData/$uid/Cart/')
              .doc()
              .set({
            //'1': FieldValue.arrayUnion(valuesToAdd)
            'Shop ID': shopID,
            'id': id,
            'selectedSize': state.sizeSelected == -1
                ? 'not applicable'
                : state.sizes[state.sizeSelected].toString(),
            'variant': state.imageSliderDocID,
            'quantity': state.quantity,
          });
        }
        //user Not logged in
        else{
          cartBloc.add(AddItemEvent(
              id: id,
              price: state.discountCal,
              size: state.sizeSelected == -1
                  ? 'not applicable'
                  : state.sizes[state.sizeSelected].toString(),
              variant: state.imageSliderDocID,
              quantity: state.quantity));
        }

        //notify
        messenger.showSnackBar(SnackBar(
          content: GestureDetector(
            onTap: () {
              /*Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const Cart(),
              ));*/
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: mediaQuery.size.width * 0.4,
                  child: const Text(
                    'Item added into the cart.',
                    style: TextStyle(overflow: TextOverflow.clip),
                  ),
                ),
                /*if (mounted) ...[
                  SizedBox(
                    width: mediaQuery.size.width * 0.4,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const Cart(),
                        ));
                        GoRouter.of(context).go('/cart');
                      },
                      child: const Text(
                        'Open Cart',
                        style: TextStyle(

                            fontWeight: FontWeight.bold,
                            fontSize: 14.5),
                      ),
                    ),
                  )
                ]*/
              ],
            ),
          ),
          duration: const Duration(seconds: 3),
        ));

        if (text == 'Buy Now') {
          navigator.push(MaterialPageRoute(
            builder: (context) {
              return const Cart();
            },
          ));
        }

      }

    }
  }
}
