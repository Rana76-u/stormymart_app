// Flutter imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stormymart_v2/Core/Utils/core_progress_bars.dart';

// Project imports:
import 'package:stormymart_v2/Core/Utils/errors_n_empty_messages.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Product/Widgets/show_products_as_grid_list_.dart';
import '../Widgets/show_product_as_horizontal_list.dart';

class ShowProductByQueryType extends StatelessWidget {
  final Future<QuerySnapshot<Map<String, dynamic>>> query;
  final String? title;
  final String listType;
  final String? thisProductID;
  const ShowProductByQueryType({super.key, required this.query,
    this.title, required this.listType, this.thisProductID});

  @override
  Widget build(BuildContext context) {

    /*var productType = ProductQueries().getPopularProducts();

    switch(query){
      case 'popular':
        productType = ProductQueries().getPopularProducts();
        break;
      case 'hotDeals':
        productType = ProductQueries().getHotDeals();
        break;
      case 'suggestedProducts':
        productType = ProductQueries().getSuggestedProducts();
        break;
      case 'searchProductByTitle':
        productType = ProductQueries().searchProductByTitle();
        //todo: more queries
      */
    /*case 'newArrivals':
        productType = Product().getNewArrivals();
        break;
      case 'bestSellers':
        productType = Product().getBestSellers();
        break;
      case 'allProducts':
        productType = Product().getAllProducts();
        break;
      case 'recentlySold':
        productType = Product().getRecentlySold();
        break;*//*
    }*/


    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: query,//Product().getPopularProducts(), productType
      builder: (BuildContext context, snapshot) {
        if(snapshot.hasData){
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              title != null ?
              showProductByQueryTypeTitle(context, title!) : const SizedBox(),

              listType == 'grid' ?
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.5),
                //todo: switch between grid and horizontal list view
                child: showProductsAsGridList(snapshot, context),
              )
              :
              showProductAsHorizontalList(snapshot, thisProductID ?? ''),
            ],
          );
        }
        else if(snapshot.connectionState == ConnectionState.waiting){
          return centeredCircularProgress();
        }
        else{
          return ErrorsAndEmptyMessages.nothingToShowMessage();
        }
      },
    );
  }
}


Widget showProductByQueryTypeTitle(BuildContext context, String title) {
  return Padding(
    padding: const EdgeInsets.only(top: 30, bottom: 20),
    child: Center(
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 40,
            overflow: TextOverflow.clip
        ),
      ),
    ),
  );
}
