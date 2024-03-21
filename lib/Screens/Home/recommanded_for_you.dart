import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:stormymart_v2/utility/globalvariable.dart';
import '../../Components/custom_image.dart';
import '../../theme/color.dart';

class RecommendedForYou extends StatelessWidget {
  const RecommendedForYou({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('/Products')
          .get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if(snapshot.hasData){
          return Expanded(
            flex: 0,
            child: ResponsiveGridList(
              horizontalGridSpacing: 10, // Horizontal space between grid items
              verticalGridSpacing: 0, // Vertical space between grid items
              horizontalGridMargin: 0, // Horizontal space around the grid
              verticalGridMargin: 0, // Vertical space around the grid
              minItemWidth: 300, // The minimum item width (can be smaller, if the layout constraints are smaller)
              minItemsPerRow: 2, // The minimum items to show in a single row. Takes precedence over minItemWidth
              maxItemsPerRow: null, // The maximum items to show in a single row. Can be useful on large screens
              listViewBuilderOptions: ListViewBuilderOptions(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                primary: true,
              ), // Options that are getting passed to the ListView.builder() function
              children: List.generate(
                  snapshot.data!.docs.length,
                      (index) {
                    if(snapshot.hasData){
                      DocumentSnapshot product = snapshot.data!.docs[index];
                      double discountCal = (product.get('price') / 100) * (100 - product.get('discount'));
                      return GestureDetector(
                        onTap: () {
                          GoRouter.of(context).go('/product/${product.id}');
                        },
                        child: SizedBox(
                          //width: 200,
                          width: MediaQuery.of(context).size.width*0.48,
                          height: 300,
                          child: Stack(
                            children: [
                              //Pulls image from variation 1's 1st image
                              FutureBuilder(
                                future: FirebaseFirestore
                                    .instance
                                    .collection('/Products/${product.id}/Variations').get(),
                                builder: (context, snapshot) {
                                  if(snapshot.hasData){
                                    String docID = snapshot.data!.docs.first.id;
                                    return FutureBuilder(
                                      future: FirebaseFirestore
                                          .instance
                                          .collection('/Products/${product.id}/Variations').doc(docID).get(),
                                      builder: (context, imageSnapshot) {
                                        if(imageSnapshot.hasData){
                                          return CustomImage(
                                            imageSnapshot.data?['images'][0],
                                            radius: 10,
                                            width: 200,
                                            height: 210,//210
                                          );
                                        }else if(imageSnapshot.connectionState == ConnectionState.waiting){
                                          return const Center(
                                            child: LinearProgressIndicator(),
                                          );
                                        }
                                        else{
                                          return const Center(
                                            child: Text(
                                              "Nothings Found",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey
                                              ),
                                            ),
                                          );
                                        }
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
                                      child: Text(
                                        "Nothings Found",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),

                              //Discount %Off
                              if(product.get('discount') != 0)...[
                                Positioned(
                                  top: 10,
                                  left: 10,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade800,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Padding(
                                      padding:   const EdgeInsets.all(7),
                                      child: Text(
                                        'Discount: ${product.get('discount')}%',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],

                              //Title
                              Positioned(
                                top: 220,
                                left: 5,
                                child: Text(
                                  product.get('title'),
                                  style: const TextStyle(
                                      overflow: TextOverflow.clip,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: Colors.black45//darker
                                  ),
                                ),
                              ),

                              //price
                              Positioned(
                                  top: 240,
                                  left: 5,
                                  child: Row(
                                    children: [
                                      Text(
                                        "Tk ${discountCal.toStringAsFixed(2)}/-",
                                        maxLines: 1,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 16,
                                            color: textColor),
                                      ),
                                    ],
                                  )
                              ),

                            ],
                          ),
                        ),
                      );
                    }
                    else{
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }
              ), // The list of widgets in the grid
            ),
          );
        }else{
          return const Center(
            child: Text(
                'NOTHING TO SHOW'
            ),
          );
        }
      },
    );
  }
}

class RecommendedForYouTitle extends StatelessWidget {
  const RecommendedForYouTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Recommended For You',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                fontFamily: 'Urbanist'
            ),
          ),

          GestureDetector(
            onTap: () {
              keyword = null;
              GoRouter.of(context).go('/search');
            },
            child: const Text(
              'See All',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  fontFamily: 'Urbanist'
              ),
            ),
          ),
        ],
      );
  }
}
