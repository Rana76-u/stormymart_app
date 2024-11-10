import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stormymart_v2/Blocks/Cart%20Bloc/cart_bloc.dart';
import 'package:stormymart_v2/Blocks/Cart%20Bloc/cart_states.dart';
import '../../Blocks/CheckOut Bloc/checkout_bloc.dart';
import '../../Blocks/CheckOut Bloc/checkout_events.dart';
import '../../utility/padding_provider.dart';
import 'item_util.dart';

class OrderSummary extends StatelessWidget {

  OrderSummary({super.key});

  double total = 0;

  double getTotal(CartState state) {
    total = 0;
    for (int i = 0; i < state.idList.length; i++) {
      if (state.checkList[i] == true) {
        total += state.priceList[i] * state.quantityList[i];
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartBloc, CartState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Order Summary",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20,),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.idList.length,
              itemBuilder: (context, index) {
                String productId =state.idList[index].trim();
                state.variantList[index].trim();
                int quantity = state.quantityList[index];

                if (state.checkList[index] == true) {
                  return FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('/Products')
                        .doc(productId.trim())
                        .get(),
                    builder: (context, productSnapshot) {
                      if (productSnapshot.hasData) {
                        double priceAfterDiscount =
                            (productSnapshot.data!.get('price') / 100) *
                                (100 - productSnapshot.data!.get('discount'));

                        total = total + (priceAfterDiscount * quantity);

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                //Texts
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.5 - 2 * paddingProvider(context) - 20,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      //Title, Price
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          //Title
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              '${productSnapshot.data!.get('title')}',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
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
                                          Padding(
                                            padding: const EdgeInsets.only(right: 20),
                                            child: Text(
                                              'BDT ${priceAfterDiscount * quantity}',
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.deepOrangeAccent,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Divider(
                              height: 35,
                              thickness: 0.2,
                            )
                          ],
                        );
                      } else if (productSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        //return loadingWidget(context, 0.4);
                        return ItemUtil().shimmerLoading(context);
                      } else {
                        return ItemUtil().errorWidget(context, 'Error Loading Data');
                      }
                    },
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),

            Text(
              "Total: BDT ${getTotal(state).toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            //Checkout Button
            Container(
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
                  BlocProvider.of<CheckoutBloc>(context).add(TransferDataEvent(state));
                  GoRouter.of(context).go('/checkout');
                },),
            ),
          ],
        );
      },
    );
  }
}


