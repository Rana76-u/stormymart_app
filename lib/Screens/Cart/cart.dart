import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stormymart_v2/Blocks/Cart%20Bloc/cart_events.dart';
import 'package:stormymart_v2/Screens/Cart/item_util.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../Blocks/Cart Bloc/cart_bloc.dart';
import '../../Blocks/Cart Bloc/cart_states.dart';
import '../../Blocks/CheckOut Bloc/checkout_bloc.dart';
import '../../Blocks/CheckOut Bloc/checkout_events.dart';
import '../../ViewModels/cart_viewmodel.dart';
import 'delivery_container.dart';

class Cart extends StatelessWidget {
  const Cart({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        GoRouter.of(context).go('/');
      },
      child: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'My Cart',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              automaticallyImplyLeading: false,
            ),
            floatingActionButton: floatingButtonWidget(state, context),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            body: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 7),
                  child: Column(
                    children: [
                      cartItems(state),
                      const SizedBox(
                        height: 150,
                      )
                    ],
                  )),
            ),
          );
        },
      ),
    );
  }

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
        future: FirebaseFirestore.instance
            .collection('userData')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('Cart')
            .orderBy('id')
            .get(),
        builder: (context, cartSnapshot) {
          if (cartSnapshot.hasData) {
            int numberOfItem = cartSnapshot.data!.docs.length;

            List<String> productIDs = [];
            for(int i=0; i<numberOfItem; i++){
              productIDs.add(cartSnapshot.data!.docs[i].get('id'));
            }

            return Card(
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DeliveryContainer(),

                  //Space
                  const SizedBox(
                    height: 10,
                  ),

                  numberOfItemsWidget(numberOfItem),

                  //Cart items
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cartSnapshot.data!.docs.length,
                        itemBuilder: (context, index) {

                          return checkIfProductExistsWidget(
                              cartSnapshot.data!.docs[index].id,
                              cartSnapshot.data!.docs[index].get('id'),
                              cartSnapshot.data!.docs[index].get('selectedSize'),
                              cartSnapshot.data!.docs[index].get('variant'),
                              cartSnapshot.data!.docs[index].get('quantity'),
                              index,
                              state,
                              numberOfItem
                          );
                        },
                      ),
                    ),
                  ),
                ],
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
      return Card(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DeliveryContainer(),

            //Space
            const SizedBox(
              height: 10,
            ),

            numberOfItemsWidget(numberOfItem),

            //Cart items
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: AnimatedSwitcher(
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
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget checkIfProductExistsWidget(String cartDocID, String productId,
      String size, String variant, int quantity, int index, CartState state, int numberOfItem) {
    return FutureBuilder<bool>(
      future: CartViewModel().checkIfCartItemExists(productId),
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
  }

  Widget cartItemWidget(
      BuildContext context, String cartItemDocID, String productId, String size,
      String variant, int quantity, int index, CartState state, int numberOfItem) {
    final provider = BlocProvider.of<CartBloc>(context);

    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('/Products')
          .doc(productId.trim())
          .get(),
      builder: (context, productSnapshot) {
        if (productSnapshot.hasData) {

          final user = FirebaseAuth.instance.currentUser;

          double priceAfterDiscount =
              (productSnapshot.data!.get('price') / 100) * (100 - productSnapshot.data!.get('discount'));

          if(user != null){
            if(index >= state.idList.length){
              provider.add(AddItemEvent(
                  id: productId, price: priceAfterDiscount, size: size,
                  variant: variant, quantity: quantity));
            }
          }

          return Card(
            elevation: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //Checkbox
                Checkbox(
                  value: state.checkList.isNotEmpty
                      ? state.checkList[index]
                      : false,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  onChanged: (value) {
                    provider.add(UpdateCheckList(index: index, isChecked: !state.checkList[index]));
                  },
                ),

                //Image
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('/Products/$productId/Variations')
                      .doc(variant)
                      .get(),
                  builder: (context, imageSnapshot) {
                    if (imageSnapshot.hasData) {
                      return GestureDetector(
                        onTap: () {
                          GoRouter.of(context).go('/product/$productId');
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8, top: 5, bottom: 5),
                          child: Container(
                            width: 95,
                            height: 95, //137 127 120 124
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: FadeInImage.memoryNetwork(
                                image: imageSnapshot.data!.get('images')[0],
                                placeholder: kTransparentImage,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    else if (imageSnapshot.connectionState == ConnectionState.waiting) {
                      return ItemUtil().loadingWidget(context, 0.4);
                    }
                    else {
                      return ItemUtil().errorWidget(context, 'Error Loading Data');
                    }
                  },
                ),

                //Texts
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.55 -
                          20, //200, 0.45
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Title
                          Text(
                            productSnapshot.data!.get('title'),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          //Price
                          Text(
                            '৳ $priceAfterDiscount',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 12,
                                color: Colors.purple,
                                fontWeight: FontWeight.bold),
                          ),

                          //Quantity
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //Size
                                  Text(
                                    'Size: $size',
                                    style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.black54,
                                        overflow: TextOverflow.ellipsis),
                                  ),

                                  //Variant
                                  Text(
                                    'Variant: $variant',
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 11, color: Colors.black54),
                                  ),
                                ],
                              ),
                              const Expanded(child: SizedBox()),
                              Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: quantitySelector(context, state, index))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                //Delete
                ItemUtil().deleteItemButton(context, user, cartItemDocID, priceAfterDiscount, index)
              ],
            ),
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


  Widget numberOfItemsWidget(int number) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Text(
        '$number items',
        style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w400),
      ),
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
}
