import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Cart/Bloc/cart_states.dart';
import '../Data/cart_services.dart';
import '../Util/item_util.dart';

class OrderSummaryWidgets {

  Widget title() {
    return const Text(
      "Order Summary",
      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    );
  }

  Widget listOfItemCalculations(BuildContext context, CartState cartState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ListView.separated(
        separatorBuilder: (context, index) {
          return const Divider(
            height: 25,
            thickness: 0.2,
          );
        },
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
                              ),
                            ),
                          ),

                          Text(
                            ' × $quantity',
                            style: const TextStyle(
                              fontSize: 14,
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

  Widget summaryTexts(String title, String amount) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            amount,
            style: const TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  Widget appDiscount(CartState cartState, num discountPercentage) {

    num priceAfterDiscount = CartServices().calculateDiscountedPrice(
        CartServices().getCartSelectedItemTotal(cartState), discountPercentage
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'App Discount: ',
              style: TextStyle(
                  fontWeight: FontWeight.bold
              )
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '(-$discountPercentage%)',
                    style: const TextStyle(
                        color: Colors.red,
                      fontWeight: FontWeight.bold
                    )
                ),
                TextSpan(
                    text: ' BDT ${priceAfterDiscount.toStringAsFixed(1)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold
                    )
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

}