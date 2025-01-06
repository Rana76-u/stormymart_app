import 'package:flutter/material.dart';
import 'package:stormymart_v2/Core/Utils/errors_n_empty_messages.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Product/Widgets/show_products_as_grid_list_.dart';
import '../Data/product_services.dart';

class ShowProductByQueryType extends StatelessWidget {
  final String query;
  final String title;
  const ShowProductByQueryType({super.key, required this.query, required this.title});

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
    }


    return FutureBuilder(
      future: productType,//Product().getPopularProducts(),
      builder: (BuildContext context, snapshot) {
        if(snapshot.hasData){
          return Column(
            children: [
              showProductByQueryTypeTitle(context, title),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.5),
                //todo: switch between grid and horizontal list view
                child: showProductsAsGridList(snapshot, context),
              )
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