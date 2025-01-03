import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stormymart_v2/Core/Appbar/Presentation/appbar_ui_mobile.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Home/Presentation/home_footer.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Home/Utils/home_imageslider.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Product/Presentation/popular_items.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Home/Utils/category_slider.dart';
import '../../../Core/Utils/padding_provider.dart';
import '../Bloc/home_bloc.dart';
import '../Bloc/home_state.dart';
import '../../Product/Widgets/all_products_title.dart';
import '../../../Core/Drawer/Presentation/category_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.only(left: 10, right: 10);
    return PopScope(
      canPop: false,
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            drawer: coreDrawer(context),
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(65),
                child: coreAppBar(context, state)
            ),
            //drawer: _drawer(context),
            body: CustomScrollView( //RefreshIndicator just above here
              slivers: <Widget>[
                //coreAppBar(context, state),

                //build body
                SliverPadding(
                  padding: padding,
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      ((context, index) => _buildBody(context, state)),
                      childCount: 1,
                    ),
                  ),
                ),

                //build footer
                SliverToBoxAdapter(
                  child: homeFooter(),
                ),
              ],
            ),
          );
        }
        ),
    );
  }

  Widget _buildBody(BuildContext context, HomeState state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingProvider(context)),
      child: Column(
        children: [
          const SizedBox(height: 10,),

          const ImageSlider(),

          const CategorySlider(),

          // Suggestion section
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
                            GoRouter.of(context).go('/product/${state.searchResults[index].id}');
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

          //HorizontalSlider(),
          //HotDealsTitle(),
          // HotDeals(),
          //RecommendedForYouTitle(),
          const PopularItemsTitle(),

          PopularItems(homeState: state,),

          const SizedBox(height: 100,),
        ],
      ),
    );
  }
}