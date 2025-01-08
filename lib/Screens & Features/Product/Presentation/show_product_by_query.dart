import 'package:flutter/material.dart';
import 'package:stormymart_v2/Core/Utils/errors_n_empty_messages.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Product/Widgets/show_products_as_grid_list_.dart';
import '../Data/product_services.dart';
import '../Widgets/show_product_as_horizontal_list.dart';

class ShowProductByQueryType extends StatelessWidget {
  final String query;
  final String title;
  final String listType;
  final String? thisProductID;
  const ShowProductByQueryType({super.key, required this.query,
    required this.title, required this.listType, this.thisProductID});

  @override
  Widget build(BuildContext context) {

    var productType = Product().getPopularProducts();

    switch(query){
      case 'popular':
        productType = Product().getPopularProducts();
        break;
      case 'hotDeals':
        productType = Product().getHotDeals();
        break;
      case 'suggestedProducts':
        productType = Product().getSuggestedProducts();
        break;
        //todo: more queries
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
        break;*/
    }


    return FutureBuilder(
      future: productType,//Product().getPopularProducts(),
      builder: (BuildContext context, snapshot) {
        if(snapshot.hasData){
          return Column(
            children: [
              showProductByQueryTypeTitle(context, title),

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
        }else{
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