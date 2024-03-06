import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stormymart_v2/Blocks/Cart%20Bloc/cart_events.dart';
import 'package:stormymart_v2/utility/globalvariable.dart';
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
            floatingActionButton: floatingButtonWidget(state),
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

  Widget floatingButtonWidget(CartState state) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: FittedBox(
          child: FloatingActionButton.extended(
            onPressed: () {},
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0),
            ),
            label: Text(
              'Total: ${state.total}/-, Proceed to Checkout',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            icon: const Icon(Icons.sell_rounded),
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

                  //selectAllWidget(context, state, numberOfItem, productIDs),

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
          } else {
            return errorWidget(context, 'Error Loading Data');
          }
        },
      );
    }
    //if not logged in
    else{
      int numberOfItem = tempProductIds.length;
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

                    return notLoggedInCartItemWidget(
                        context,
                        state,
                        numberOfItem,
                        index,
                        tempProductIds[index],
                        tempVariants[index],
                        tempSizes[index],
                        tempQuantities[index]
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

  Widget notLoggedInCartItemWidget(BuildContext context, CartState state, int numberOfItem, int index,
      String productId, String variant, String size, int quantity) {
    final provider = BlocProvider.of<CartBloc>(context);

    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('/Products')
          .doc(productId)
          .get(),
      builder: (context, productSnapshot) {
        if (productSnapshot.hasData) {
          double priceAfterDiscount =
              (productSnapshot.data!.get('price') / 100) * (100 - productSnapshot.data!.get('discount'));

          if(state.checkList.isEmpty){
            provider.add(InitCheckListEvent(numberOfItem: numberOfItem));
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
                    //if item is already checked then onChange will toggle into unchecked
                    //so isAllSelected is not true anymore
                    if(state.checkList[index] == true){
                      //state.isAllSelected = false;
                      state.checkList[index] = !state.checkList[index];
                      //remove item from list
                      provider.add(RemoveSelectedItemEvent(itemPrice: priceAfterDiscount, itemId: productId.trim()));
                    }
                    else{
                      state.checkList[index] = !state.checkList[index];
                      //add item into list
                      provider.add(AddSelectedItemEvent(itemPrice: priceAfterDiscount, itemId: productId.trim()));
                    }

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
                Padding(
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
                                    //delete from tempList
                                    provider.add(DeleteFromTempList(index: index));
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) =>
                                          const Cart(),
                                    ));
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
                ),
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

  Widget checkIfProductExistsWidget(String cartDocID, String productId,
      String size, String variant, int quantity, int index, CartState state, int numberOfItem) {
    return FutureBuilder<bool>(
      future: CartViewModel().checkIfCartItemExists(productId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingWidget(context, 0.4); // or any loading indicator
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          bool productExists = snapshot.data ?? false;
          if (productExists) {
            //delete the item

            return cartItemNotAvailableWidget(context, cartDocID, null, index);
          } else {
            //below line was swaped
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
          double priceAfterDiscount =
              (productSnapshot.data!.get('price') / 100) * (100 - productSnapshot.data!.get('discount'));

          if(state.checkList.isEmpty){
            provider.add(InitCheckListEvent(numberOfItem: numberOfItem));
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

                    //if item is already checked then onChange will toggle into unchecked
                    //so isAllSelected is not true anymore
                    if(state.checkList[index] == true){
                      //state.isAllSelected = false;
                      state.checkList[index] = !state.checkList[index];
                      //remove item from list
                      provider.add(RemoveSelectedItemEvent(itemPrice: priceAfterDiscount, itemId: productId.trim()));
                    }else{
                      state.checkList[index] = !state.checkList[index];
                      //add item into list
                      provider.add(AddSelectedItemEvent(itemPrice: priceAfterDiscount, itemId: productId.trim()));
                    }

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
                Padding(
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
                                    CartViewModel().deleteDocument(
                                        context, cartItemDocID, priceAfterDiscount, index
                                    );
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) =>
                                          const Cart(),
                                    ));
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
                ),
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

  Widget cartItemNotAvailableWidget(BuildContext context, String cartItemDocID, double? price, int index) {
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
          Padding(
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
                              CartViewModel().deleteDocument(
                                  context, cartItemDocID, null, index
                              );
                              Navigator.of(context)
                                  .push(MaterialPageRoute(
                                builder: (context) =>
                                    const Cart(),
                              ));
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
          ),
        ],
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

  /*Widget selectAllWidget(BuildContext context, CartState state, int numberOfItem, List<String> productIDs) {
    final provider = BlocProvider.of<CartBloc>(context);

    return Row(
      children: [
        Checkbox(
          value: state.isAllSelected,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          onChanged: (value) async {
            state.priceList = [];
            state.idList = [];

            if(value == true) {
              for(int i=0; i<numberOfItem; i++){

                DocumentSnapshot snapshot = await FirebaseFirestore.instance
                    .collection('/Products')
                    .doc(productIDs[i]).get();

                state.priceList.add(snapshot.get('field'));
              }
            }

            provider.add(SelectAllCheckList(isSelectAll: !state.isAllSelected, numberOfItems: numberOfItem));
          },
        ),

        const Text(
          'Select All',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13
          ),
        )
      ],
    );
  }*/
}
