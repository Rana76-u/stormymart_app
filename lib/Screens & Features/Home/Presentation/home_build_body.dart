// Flutter imports:
import 'package:flutter/material.dart';
import 'package:stormymart_v2/Core/Utils/padding_provider.dart';

// Project imports:
import '../../Product/Data/product_queries.dart';
import '../../Product/Presentation/show_product_by_query.dart';
import '../Bloc/home_state.dart';
import '../Utils/category_slider.dart';
import '../Utils/home_imageslider.dart';

Widget homeBuildBody(BuildContext context, HomeState state) {
  return Padding(
    padding: paddingProvider(context),
    child: Column(
      children: [
        const SizedBox(height: 10,),
    
        const ImageSlider(),
    
        const CategorySlider(),
    
        ShowProductByQueryType(query: ProductQueries().getPopularProducts(), title: 'Popular Items', listType: 'grid'),
    
        ShowProductByQueryType(query: ProductQueries().getHotDeals(), title: 'Hot Deals', listType: 'grid'),
    
        ShowProductByQueryType(query: ProductQueries().getAllProducts(), title: 'Featured', listType: 'grid'),
    
        const SizedBox(height: 100,),
      ],
    ),
  );
}
