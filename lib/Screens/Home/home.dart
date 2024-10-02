import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stormymart_v2/Screens/Home/Home%20AppBar/appbar_widgets.dart';
import 'package:stormymart_v2/Screens/Home/carousel_slider.dart';
import 'package:stormymart_v2/Screens/Home/horizontal_category.dart';
import 'package:stormymart_v2/Screens/Home/hot_deals.dart';
import 'package:stormymart_v2/Screens/Home/imageslider.dart';
import 'package:stormymart_v2/Screens/Home/recommanded_for_you.dart';
import 'package:stormymart_v2/Screens/Profile/profile.dart';
import 'package:stormymart_v2/utility/globalvariable.dart';
import 'package:transparent_image/transparent_image.dart';

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

  Widget _drawer(BuildContext context){
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(0),
            bottomRight: Radius.circular(0)),
      ),
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
                color: Color(0xFF0d1b2a)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if(FirebaseAuth.instance.currentUser != null)...[
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const Profile(),)
                      );
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          height: 45,
                          width: 45,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: FadeInImage.memoryNetwork(
                              image: FirebaseAuth.instance.currentUser!.photoURL ??
                                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSgBhcplevwUKGRs1P-Ps8Mwf2wOwnW_R_JIA&usqp=CAU',
                              placeholder: kTransparentImage,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14,),
                        SizedBox(
                          width: 170,
                          child: Text(
                            FirebaseAuth.instance.currentUser!.displayName ?? "",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Colors.white,
                                overflow: TextOverflow.ellipsis
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ]
                else...[
                  SizedBox(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                        ),
                      ),
                      onPressed: () {
                        //open login page
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const Profile(),
                        ));
                      },
                      child: const Text(
                        'Sign in using Google',
                        style: TextStyle(
                            
                            fontWeight: FontWeight.bold,
                            fontSize: 13
                        ),
                      ),
                    ),
                  ),
                ],
                //const Expanded(child: SizedBox()),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Browse',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Colors.white
                      ),
                    ),
                    Text(
                      'StormyMart',
                      style: TextStyle(
                          fontSize: 21,
                          
                          fontWeight: FontWeight.w700,
                          color: Colors.white
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          //Drawer items
          FutureBuilder(
            future: FirebaseFirestore.instance.collection('/Category').doc('/Drawer').get(),
            builder: (context, snapshot) {
              if(snapshot.hasData){
                int length = snapshot.data!.data()!.keys.length;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: length,
                  itemBuilder: (context, index) {
                    String title = snapshot.data!.data()!.keys.elementAt(index);
                    List<dynamic> subCategories = snapshot.data!.get(title);
                    return ExpansionTile(
                      iconColor: Colors.amber,
                      textColor: Colors.amber,
                      title: Text(title),
                      childrenPadding: const EdgeInsets.only(left: 60),
                      children: List.generate(
                        subCategories.length,
                            (index) {
                          return ListTile(
                            title: Text(subCategories[index]),
                            onTap: () {
                              keyword = subCategories[index];
                              GoRouter.of(context).go('/search/item/$keyword');
                            },
                          );
                        },
                      ),
                    );
                  },
                );
              }
              else if(snapshot.connectionState == ConnectionState.waiting){
                return const Center(
                  child: LinearProgressIndicator(),
                );
              }
              else{
                return const Center(
                  child: Text('Nothings Here'),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context){
    return Padding(
      padding: MediaQuery.of(context).size.width >= 600 ?
      EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.15) :
      const EdgeInsets.symmetric(horizontal: 0), //EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.1)
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
              HorizontalSlider(),
              SizedBox(height: 10,),
              HotDealsTitle(),
              HotDeals(),
              RecommendedForYouTitle(),
              SizedBox(height: 10,),
              //MostPopularCategory(),
              RecommendedForYou(),
            ],
          ),
          SizedBox(height: 100,)
        ],
      ),
    );
  }
}