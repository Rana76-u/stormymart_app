import 'package:flutter/material.dart';
import 'package:stormymart_v2/Screens/Home/Home%20AppBar/appbar_widgets.dart';
import 'package:stormymart_v2/Screens/Home/imageslider.dart';
import 'package:stormymart_v2/Screens/Home/Body/all_products.dart';
import 'Body/all_products_title.dart';
import 'motoline.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.only(left: 10, right: 10);
    return PopScope(
      canPop: false,
      child: Scaffold(
        //drawer: _drawer(context),
        body: CustomScrollView( //RefreshIndicator just above here
          slivers: <Widget>[
            homeAppbar(context),

            //build body
            SliverPadding(
              padding: padding,
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  ((context, index) => _buildBody(context)),
                  childCount: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context){
    return Padding(
      padding: MediaQuery.of(context).size.width <= 600 ?
      const EdgeInsets.symmetric(horizontal: 15)
          :
      MediaQuery.of(context).size.width <= 1565 ?
      EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.065)
          :
      EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.15), //EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.1)
      child: const Column(
        children: [

          ImageSlider(),
          SizedBox(height: 10,),
          //Replace with Carosoul
          //GridViewPart(),
          Column(
            children: [
              SizedBox(height: 20,),
              MotoLine(),
              //HorizontalSlider(),
              SizedBox(height: 60,),
              //HotDealsTitle(),
             // HotDeals(),
              //RecommendedForYouTitle(),
              AllProductsTitle(),
              SizedBox(height: 40,),
              //MostPopularCategory(),
              AllProducts(),
            ],
          ),
          SizedBox(height: 100,)
        ],
      ),
    );
  }
}