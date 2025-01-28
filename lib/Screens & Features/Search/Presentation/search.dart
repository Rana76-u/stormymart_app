// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:stormymart_v2/Core/Utils/core_progress_bars.dart';
import 'package:stormymart_v2/Core/Utils/padding_provider.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Search/Bloc/search_bloc.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Search/Bloc/search_states.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Search/Presentation/search_widgets.dart';
import '../../Product/Data/product_queries.dart';
import '../../Product/Presentation/show_product_by_query.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchStates>(
      builder: (context, state) {
        return Scaffold(
          floatingActionButton: SearchWidgets().floatingActionButtonWidget(context, state),
          body: Padding(
            padding: paddingProvider(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Space From Top
                const SizedBox(height: 20,),

                SearchWidgets().title(),

                SearchWidgets().searchField(context, state),

                // A loading indicator while the search is in progress
                state.isSearching ? centeredLinearProgress(context) : const SizedBox(),

                //SearchWidgets().filteringWidget(context, state),

                SearchWidgets().showSearchedText(context, state),

                //Show Found Items
                Expanded(
                    child: SingleChildScrollView(
                      child: ShowProductByQueryType(
                          query: ProductQueries().searchProductByTitle(state),
                          listType: 'grid'
                      ),
                    ),
                  ),

              ],
            ),
          ),
        );
      },
    );
  }
}


