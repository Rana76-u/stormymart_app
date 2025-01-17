// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

// Project imports:
import 'package:stormymart_v2/Screens%20&%20Features/Cart/Data/cart_services.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Product/Widgets/product_card.dart';

Widget showProductAsHorizontalList(AsyncSnapshot<QuerySnapshot> snapshot, String thisProductID) {
  List itemRepetitionChecker = [];

  final products = snapshot.data!;

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: SizedBox(
      height: 465,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: products.docs.length,
        itemBuilder: (context, index) {
          final product = products.docs[index].data() as Map<String, dynamic>;

          if(itemRepetitionChecker.contains(products.docs[index].id) || products.docs[index].id == thisProductID){
            return const SizedBox();
          }
          else{
            itemRepetitionChecker.add(products.docs[index].id);

            num price = product['price'];
            num discount = product['discount'];
            num priceAfterDiscount = CartServices().calculateDiscountedPrice(price.toDouble(), discount.toDouble());

            return productCard(
                context,
                products.docs[index].id,
                product['discount'],
                priceAfterDiscount,
                product['title'],
                product['sold']
            );
          }

        },
      ),
    ),
  );
}
