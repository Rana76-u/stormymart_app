import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Cart/Data/cart_queries.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Cart/Data/cart_services.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Cart/Widgets/cart_item_widgets.dart';
import '../../CheckOut/Bloc/checkout_bloc.dart';
import '../../CheckOut/Bloc/checkout_events.dart';
import '../Bloc/cart_bloc.dart';
import '../Bloc/cart_events.dart';
import '../Bloc/cart_states.dart';
import '../Data/on_press_functions.dart';
import '../Util/item_util.dart';

class CartWidgets {
  Widget floatingButtonWidget(CartState state, BuildContext context) {
    final provider = BlocProvider.of<CartBloc>(context);

    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: FittedBox(
          child: Row(
            children: [
              FloatingActionButton.extended(
                onPressed: () async {
                  provider.add(SelectAllCheckList(isSelectAll: !state.isAllSelected));
                },
                heroTag: "selectAllBtn",
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.0),
                ),
                label: const Text(
                  'Select All',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                icon: state.isAllSelected ? const Icon(Icons.check_circle) : const Icon(Icons.radio_button_unchecked_rounded),
              ),

              const SizedBox(width: 10,),

              FloatingActionButton.extended(
                onPressed: () {
                  BlocProvider.of<CheckoutBloc>(context).add(ResetCheckoutEvent());
                  BlocProvider.of<CheckoutBloc>(context).add(TransferDataEvent(state));
                  GoRouter.of(context).go('/checkout');
                },
                heroTag: "checkoutBtn",
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.0),
                ),
                label: Text(
                  'Total: ${state.total}/-, Proceed to Checkout',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                icon: const Icon(Icons.sell_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget cartItems(CartState state) {
    //if user logged in
    if(FirebaseAuth.instance.currentUser != null){
      return FutureBuilder(
        future: CartQueries().getCartItems(),
        builder: (context, cartSnapshot) {
          if (cartSnapshot.hasData) {
            int numberOfItem = cartSnapshot.data!.docs.length;

            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: ListView.separated(
                separatorBuilder: (context, index) => const Divider(height: 35, thickness: 0.2, ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cartSnapshot.data!.docs.length,
                itemBuilder: (context, index) {

                  return cartItemWidget(
                      context,
                      cartSnapshot.data!.docs[index].id,
                      cartSnapshot.data!.docs[index].get('id'),
                      cartSnapshot.data!.docs[index].get('selectedSize'),
                      cartSnapshot.data!.docs[index].get('variant'),
                      cartSnapshot.data!.docs[index].get('quantity'),
                      index,
                      state,
                      numberOfItem);
                  /*return checkIfProductExistsWidget(
                      cartSnapshot.data!.docs[index].id,
                      cartSnapshot.data!.docs[index].get('id'),
                      cartSnapshot.data!.docs[index].get('selectedSize'),
                      cartSnapshot.data!.docs[index].get('variant'),
                      cartSnapshot.data!.docs[index].get('quantity'),
                      index,
                      state,
                      numberOfItem
                  );*/
                },
              ),
            );
          }
          else if (cartSnapshot.connectionState == ConnectionState.waiting) {
            return ItemUtil().loadingWidget(context, 0.4);
          }
          else {
            return ItemUtil().errorWidget(context, 'Error Loading Data');
          }
        },
      );
    }
    //if not logged in
    else{
      int numberOfItem = state.idList.length;
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: numberOfItem,
          itemBuilder: (context, index) {

            return cartItemWidget(
              context,
              'cartItemDocID',
              state.idList[index],
              state.sizeList[index],
              state.variantList[index],
              state.quantityList[index],
              index,
              state,
              numberOfItem,
            );
          },
        ),
      );
    }
  }

  Widget cartItemWidget(
      BuildContext context, String cartItemDocID, String productId, String size,
      String variant, int quantity, int index, CartState state, int numberOfItem) {
    final provider = BlocProvider.of<CartBloc>(context);

    return FutureBuilder(
      future: CartQueries().loadProduct(productId),
      builder: (context, productSnapshot) {
        if (productSnapshot.hasData) {

          final user = FirebaseAuth.instance.currentUser;

          final priceAfterDiscount = CartServices().calculateDiscountedPrice(
              productSnapshot.data!.get('price'), productSnapshot.data!.get('discount'));

          if(user != null){
            if(index >= state.idList.length){
              provider.add(AddItemEvent(
                  id: productId, price: priceAfterDiscount, size: size,
                  variant: variant, quantity: quantity));
            }
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CartItemWidgets().checkBox(
                  state,
                  index,
                  CartServices().getCheckBoxValueForIndividual(state, index),
                  () => CartOnPressFunctions().onIndividualItemCheckBoxClicked(context, index, !state.checkList[index])),

              CartItemWidgets().image(productId, variant),

              //Text Items
              CartItemWidgets().texts(
                  context, state, index, productSnapshot.data!.get('title'),
                  priceAfterDiscount, size, variant),

              //Delete
              ItemUtil().deleteItemButton(context, user, cartItemDocID, priceAfterDiscount, index)
            ],
          );
        }
        else if (productSnapshot.connectionState == ConnectionState.waiting) {
          //return loadingWidget(context, 0.4);
          return ItemUtil().shimmerLoading(context);
        }
        else {
          return ItemUtil().errorWidget(context, 'Error Loading Data');
        }
      },
    );
  }


  Widget cartTitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Center(
        child: Text(
          'My Cart',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 40
          ),
        ),
      ),
    );
  }

  Widget numberOfItemsWidget(int number) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Text(
        'Total : $number items',
        style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w400),
      ),
    );
  }

  Widget selectAllWidget(BuildContext context, CartState state) {
    return Row(
      children: [
        CartItemWidgets().checkBox(
            state,
            1,
            state.checkList.every((element) => element == true),
                () => CartOnPressFunctions().onSelectAllItemCheckBoxClicked(context, state, !state.checkList.every((element) => element == true))
        ),

        const Text('Select All')
      ],
    );
  }

  Widget quantitySelector(BuildContext context, CartState state, int index) {
    final provider = BlocProvider.of<CartBloc>(context);
    int quantity = state.quantityList[index];

    return SizedBox(
      height: 30,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(
                Icons.remove,
                size: 15,
              ),
              onPressed: () {
                // Decrement quantity
                if (quantity != 1) {
                  quantity--;
                }
                provider.add(UpdateQuantityList(index: index, quantity: quantity));
              },
            ),
            Text('${state.quantityList[index]}'),
            IconButton(
              icon: const Icon(Icons.add, size: 15,),
              onPressed: () {
                // Increment quantity
                quantity++;
                provider.add(UpdateQuantityList(index: index, quantity: quantity));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget checkOutButton(BuildContext context, CartState cartState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        height: 55,
        width: double.infinity,
        margin: const EdgeInsets.only(top: 20),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepOrangeAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          child: const Text(
            "Checkout",
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white
            ),
          ),
          onPressed: () {
            BlocProvider.of<CheckoutBloc>(context).add(ResetCheckoutEvent());
            BlocProvider.of<CheckoutBloc>(context).add(TransferDataEvent(cartState));
            GoRouter.of(context).go('/checkout');
          },),
      ),
    );
  }
}


/*  Widget checkIfProductExistsWidget(String cartDocID, String productId,
      String size, String variant, int quantity, int index, CartState state, int numberOfItem) {
    return FutureBuilder<bool>(
      future: CartServices().checkIfCartItemExists(productId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ItemUtil().loadingWidget(context, 0.4); // or any loading indicator
        }
        else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        else {
          bool productExists = snapshot.data ?? false;
          if (productExists) {
            //delete the item

            return ItemUtil().cartItemNotAvailableWidget(context, cartDocID, null, index);
          } else {
            //below line was swapped
            return cartItemWidget(context, cartDocID, productId, size, variant,
                quantity, index, state, numberOfItem);
          }
        }
      },
    );
  }*/