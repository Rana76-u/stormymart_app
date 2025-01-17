// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

// Project imports:
import 'package:stormymart_v2/Screens%20&%20Features/Product/Widgets/product_card.dart';
import '../../../Core/Utils/core_progress_bars.dart';

Widget showProductsAsGridList(AsyncSnapshot<QuerySnapshot> snapshot, BuildContext context) {
  return ResponsiveGridList(
    horizontalGridSpacing: 2.5, // Horizontal space between grid items
    verticalGridSpacing: 0, // Vertical space between grid items
    horizontalGridMargin: 0, // Horizontal space around the grid
    verticalGridMargin: 0, // Vertical space around the grid
    minItemWidth: 250, // The minimum item width (can be smaller, if the layout constraints are smaller)
    minItemsPerRow: 2, // The minimum items to show in a single row. Takes precedence over minItemWidth
    maxItemsPerRow: 5, // The maximum items to show in a single row. Can be useful on large screens
    listViewBuilderOptions: ListViewBuilderOptions(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      primary: true,
    ), // Options that are getting passed to the ListView.builder() function
    children: List.generate(
        snapshot.data!.docs.length,
            (index) {
          if(snapshot.hasData){
            DocumentSnapshot product = snapshot.data!.docs[index];
            num price = product.get('price');
            num discount = product.get('discount');
            num discountCal = (price / 100) * (100 - discount);

            return productCard(
              context,
              product.id,
              (product.get('discount')),
              discountCal,
              product.get('title'),
              product.get('sold'),
            );
          }
          else{
            return centeredLinearProgress(context);
          }
        }
    ), // The list of widgets in the grid
  );
}
