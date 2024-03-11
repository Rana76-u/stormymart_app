import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stormymart_v2/Blocks/Cart%20Bloc/cart_events.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../Blocks/Cart Bloc/cart_bloc.dart';
import '../../Blocks/Cart Bloc/cart_states.dart';
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
            return loadingWidget(context, 0.4);
          }
          else {
            return errorWidget(context, 'Error Loading Data');
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
          return loadingWidget(context, 0.4); // or any loading indicator
        }
        else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        else {
          bool productExists = snapshot.data ?? false;
          if (productExists) {
            //delete the item

            return cartItemNotAvailableWidget(context, cartDocID, null, index);
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
                  id: cartItemDocID, price: priceAfterDiscount, size: size,
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
                          /*Get.to(
                            ProductScreen(productId: productId),
                            //transition: Transition.fade
                          );*/
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
                    } else if (productSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return loadingWidget(context, 0.4);
                    } else {
                      return errorWidget(context, 'Error Loading Data');
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

                          //Quantity
                          Text(
                            'Quantity: $quantity',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                //Delete
                deleteItemButton(context, user, cartItemDocID, priceAfterDiscount, index)
              ],
            ),
          );
        }
        else if (productSnapshot.connectionState == ConnectionState.waiting) {
          //return loadingWidget(context, 0.4);
          return shimmerLoading(context);
        }
        else {
          return errorWidget(context, 'Error Loading Data');
        }
      },
    );
  }

  Widget deleteItemButton(BuildContext context, final user, String? cartItemDocID,
      double? priceAfterDiscount, int? index) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Please Confirm'),
                content: const Text(
                    'Are you sure you want to delete this item?'),
                actions: [
                  // The "Yes" button
                  TextButton(
                      onPressed: () {
                        if(user != null){
                          CartViewModel().deleteDocument(
                              context, cartItemDocID!, priceAfterDiscount, index!
                          );
                        }

                        BlocProvider.of<CartBloc>(context).add(DeleteItemEvent(index: index!));
                        Navigator.of(context).pop();
                      },
                      child: const Text('Yes')),
                  TextButton(
                      onPressed: () {
                        // Close the dialog
                        Navigator.of(context).pop();
                      },
                      child: const Text('No'))
                ],
              );
            },
          );
        },
        child: const SizedBox(
          child: Icon(
            Icons.delete_forever,
            color: Colors.red,
          ),
        ),
      ),
    );
  }


  Widget cartItemNotAvailableWidget(BuildContext context, String cartItemDocID, double? price, int index) {

    final user = FirebaseAuth.instance.currentUser;

    return Card(
      elevation: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //Checkbox
          Checkbox(
            value: false,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)),
            onChanged: (value) {},
          ),

          //Error Text
          errorWidget(context, "Item Is Not Listed Anymore"),

          //Delete
          deleteItemButton(context, user, cartItemDocID, price, index)
        ],
      ),
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

  Widget containerWidget(double? width) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Container(
        height: 10,
        width: width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.shade200
        ),
      ),
    );
  }


  Widget shimmerLoading(BuildContext context) {
    return Card(
      elevation: 0,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade200,
        highlightColor: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //Checkbox
            Checkbox(
              value: false,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              onChanged: (value) {},
            ),

            //Image
            Padding(
              padding: const EdgeInsets.only(right: 8, top: 5, bottom: 5),
              child: Container(
                width: 95,
                height: 95, //137 127 120 124
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.shade200
                ),
              ),
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
                      containerWidget(null),

                      //Price
                      containerWidget(50),

                      //Size
                      containerWidget(90),

                      //Variant
                      containerWidget(100),

                      //Quantity
                      containerWidget(80),

                    ],
                  ),
                ),
              ),
            ),

            //Delete
            const Padding(
              padding: EdgeInsets.only(right: 10),
              child: SizedBox(
                child: Icon(
                  Icons.delete_forever,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget loadingWidget(BuildContext context, double size) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * size,
        height: 1,
        child: const LinearProgressIndicator(),
      ),
    );
  }

  Widget errorWidget(BuildContext context, String text) {
    return Center(
      child: Text(text),
    );
  }
}
