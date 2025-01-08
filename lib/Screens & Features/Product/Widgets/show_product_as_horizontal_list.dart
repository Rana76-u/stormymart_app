import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
            num priceAfterDiscount = (price / 100) * (100 - discount);

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