import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stormymart_v2/Screens/Home/Footer/home_footer.dart';
import 'package:stormymart_v2/Screens/Home/Home%20AppBar/appbar_widgets.dart';
import 'package:stormymart_v2/Screens/Home/imageslider.dart';
import 'package:stormymart_v2/Screens/Home/Body/all_products.dart';
import '../../Blocks/Home Bloc/home_bloc.dart';
import '../../Blocks/Home Bloc/home_state.dart';
import 'Body/all_products_title.dart';
import 'motoline.dart';

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
            //drawer: _drawer(context),
            body: CustomScrollView( //RefreshIndicator just above here
              slivers: <Widget>[
                homeAppbar(context, state),

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
      padding: MediaQuery.of(context).size.width <= 600 ?
      const EdgeInsets.symmetric(horizontal: 15)
          :
      MediaQuery.of(context).size.width <= 1565 ?
      EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.065)
          :
      EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.15),
      child: Column(
        children: [
          const ImageSlider(),
          const SizedBox(height: 10,),
          const SizedBox(height: 20,),
          const MotoLine(),
          //HorizontalSlider(),
          const SizedBox(height: 60,),
          //HotDealsTitle(),
          // HotDeals(),
          //RecommendedForYouTitle(),
          const AllProductsTitle(),
          const SizedBox(height: 40,),
          //MostPopularCategory(),
          AllProducts(homeState: state,),

          const SizedBox(height: 100,),
        ],
      ),
    );
  }
}