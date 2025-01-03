import 'package:flutter/material.dart';
import 'package:stormymart_v2/Core/Utils/errors_n_empty_messages.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Product/Data/product_services.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Product/Widgets/show_products_as_grid_list_.dart';
import '../../Home/Bloc/home_state.dart';

class PopularItems extends StatelessWidget {
  final HomeState homeState;
  const PopularItems({super.key, required this.homeState});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Product().getPopularProducts(),
      builder: (BuildContext context, snapshot) {
        if(snapshot.hasData){
          return showProductsAsGridList(snapshot, context);
        }else{
          return ErrorsAndEmptyMessages.nothingToShowMessage();
        }
      },
    );
  }
}
