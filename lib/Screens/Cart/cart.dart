import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stormymart_v2/Blocks/Cart%20Bloc/cart_events.dart';
import 'package:stormymart_v2/Blocks/Home%20Bloc/home_bloc.dart';
import 'package:stormymart_v2/Blocks/Home%20Bloc/home_state.dart';
import 'package:stormymart_v2/Screens/Cart/item_util.dart';
import 'package:stormymart_v2/Screens/Cart/order_summary.dart';
import 'package:stormymart_v2/utility/padding_provider.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../Blocks/Cart Bloc/cart_bloc.dart';
import '../../Blocks/Cart Bloc/cart_states.dart';
import '../../Blocks/CheckOut Bloc/checkout_bloc.dart';
import '../../Blocks/CheckOut Bloc/checkout_events.dart';
import '../../ViewModels/cart_viewmodel.dart';
import '../Home/Footer/home_footer.dart';
import '../Home/Home AppBar/appbar_widgets.dart';

class Cart extends StatelessWidget {
  const Cart({super.key});

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.only(left: 10, right: 10);
    return PopScope(
      canPop: false,
      child: BlocConsumer<CartBloc, CartState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              //floatingActionButton: floatingButtonWidget(state, context),
              //floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
              //drawer: _drawer(context),
              body: CustomScrollView( //RefreshIndicator just above here
                slivers: <Widget>[
                  BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) {
                      return homeAppbar(context, state);
                    },
                  ),

                  //build body
                  SliverPadding(
                    padding: padding,
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        ((context, index) => _buildBody(context, state)),
                        childCount: 1,
                      ),
                    ),
                  ),

                  //build footer
                  SliverToBoxAdapter(
                    child: homeFooter(),
                  ),
                ],
              ),
            );
          }
      ),
    );
  }

  Widget _buildBody(BuildContext context, CartState state) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: paddingProvider(context)),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: cartItems(state)
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5 - 2 * paddingProvider(context) - 20,
                    child: OrderSummary()
                ),
              ],
            ),

            const SizedBox(
              height: 150,
            )
          ],
        )
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

            return Padding(
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
      return Padding(
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

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //Checkbox
                  Checkbox(
                    value: state.checkList.isNotEmpty
                        ? state.checkList[index]
                        : false,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    /*shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),*/
                    checkColor: Colors.white,
                    activeColor: Colors.deepOrange,
                    side: WidgetStateBorderSide.resolveWith(
                          (Set<WidgetState> states) {
                        if (states.contains(WidgetState.selected)) {
                          return const BorderSide(width: 2, color: Colors.deepOrange);
                        }
                        return const BorderSide(width: 1, color: Colors.deepOrangeAccent);
                      },
                    ),
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
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: Container(
                              width: 75,
                              height: 75,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
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
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.35, // * 0.55 - 20
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Title, Price
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //Title
                            Expanded(
                              flex: 1,
                              child: Text(
                                productSnapshot.data!.get('title'),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis
                                ),
                              ),
                            ),

                            //Space
                            const SizedBox(width: 30),

                            //Price
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Text(
                                '৳ $priceAfterDiscount',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 19,
                                    color: Colors.deepOrangeAccent,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Size, Variant & Quantity
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
                                padding: const EdgeInsets.only(right: 10),
                                child: quantitySelector(context, state, index))
                          ],
                        ),
                      ],
                    ),
                  ),

                  //Delete
                  ItemUtil().deleteItemButton(context, user, cartItemDocID, priceAfterDiscount, index)
                ],
              ),
              const Divider(height: 35, thickness: 0.2, )
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
