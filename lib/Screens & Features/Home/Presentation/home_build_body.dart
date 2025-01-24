// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import '../../Product/Data/product_queries.dart';
import '../../Product/Presentation/show_product_by_query.dart';
import '../Bloc/home_state.dart';
import '../Utils/category_slider.dart';
import '../Utils/home_imageslider.dart';

Widget homeBuildBody(BuildContext context, HomeState state) {
  return Column(
    children: [
      const SizedBox(height: 10,),

      const ImageSlider(),

      const CategorySlider(),

      ///todo: Suggestion section (May Remove)
      if (state.searchResults.isNotEmpty)
        SizedBox(
          width: 700,
          child: Material(
            elevation: 5,
            child: Container(
              color: Colors.white,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
              ),
              child: ListView.builder(
                itemCount: state.searchResults.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: GestureDetector(
                      onTap: () {
                        GoRouter.of(context).push('/product/${state.searchResults[index].id}');
                        /*setState(() {
                                searchedText = searchResults[index].get('title');
                                isTyping = false;
                                _searchController.clear();
                              });
                              performSearch(_searchResults[index].get('title'));*/
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          state.searchResults[index].get('title'),
                          maxLines: 1,
                          style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),

      ShowProductByQueryType(query: ProductQueries().getPopularProducts(), title: 'Popular Items', listType: 'grid'),

      ShowProductByQueryType(query: ProductQueries().getHotDeals(), title: 'Hot Deals', listType: 'grid'),

      const SizedBox(height: 100,),
    ],
  );
}
