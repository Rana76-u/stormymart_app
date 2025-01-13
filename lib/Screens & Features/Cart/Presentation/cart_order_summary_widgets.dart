import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Cart/Bloc/cart_states.dart';
import '../../../Blocks/CheckOut Bloc/checkout_bloc.dart';
import '../../../Blocks/CheckOut Bloc/checkout_events.dart';
import '../Data/cart_services.dart';
import '../Util/item_util.dart';

class OrderSummaryWidgets {

  Widget title() {
    return const Text(
      "Order Summary",
      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    );
  }

  Widget total(CartState cartState) {
    return Text(
      "Total: BDT ${CartServices().getCartSelectedItemTotal(cartState).toStringAsFixed(2)}",
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget checkOutButton(BuildContext context, CartState cartState) {
    return Container(
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
    );
  }

  Widget listOfItemCalculations(BuildContext context, CartState cartState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: cartState.idList.length,
        itemBuilder: (context, index) {
          String productId =cartState.idList[index].trim();
          cartState.variantList[index].trim();
          int quantity = cartState.quantityList[index];

          if (cartState.checkList[index] == true) {
            return FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('/Products')
                  .doc(productId.trim())
                  .get(),
              builder: (context, productSnapshot) {
                if (productSnapshot.hasData) {
                  double priceAfterDiscount = CartServices().calculateDiscountedPrice(
                      productSnapshot.data!.get('price'),
                      productSnapshot.data!.get('discount')
                  );

                  CartServices().setTotal(
                      CartServices().getCartSelectedItemTotal(cartState) + (priceAfterDiscount * quantity));

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          //Title
                          Expanded(
                            child: Text(
                              '${productSnapshot.data!.get('title')}',
                              maxLines: 1,
                              overflow: TextOverflow.visible,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          Text(
                            ' × $quantity',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          //Space
                          const SizedBox(width: 30),

                          //Price
                          Text(
                            'BDT ${priceAfterDiscount * quantity}',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.deepOrangeAccent,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const Divider(
                        height: 35,
                        thickness: 0.2,
                      )
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
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

}