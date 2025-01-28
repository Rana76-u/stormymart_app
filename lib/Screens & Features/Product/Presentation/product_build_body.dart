// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:stormymart_v2/Screens%20&%20Features/Product/Presentation/show_product_by_query.dart';
import '../Bloc/product_bloc.dart';
import '../Bloc/product_events.dart';
import '../Bloc/product_states.dart';
import '../Data/product_queries.dart';
import '../Widgets/View Product/view_product_widgets.dart';

Widget productBuildBody(BuildContext context, ProductState state, String id) {
  final productBloc = BlocProvider.of<ProductBloc>(context);

  if (id.isEmpty) {
    return const Center(child: Text('Invalid product ID'));
  }
  else{
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('Products')
          .doc(id)
          .get()
          .then((value) => value),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          num price = snapshot.data!.get('price');
          num discount = snapshot.data!.get('discount');
          num quantityAvailable = snapshot.data!.get('quantityAvailable');
          List<String> sizes = List<String>.from(snapshot.data!.get('size'));

          productBloc.add(UpdateDiscountCal((price / 100) * (100 - discount)));
          productBloc.add(UpdateSizes(sizes));

          return Column(
            children: [
              ViewProductWidgets()
                  .getImageSliderWidget(id, state.imageSliderDocID),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ViewProductWidgets().variationWidget(state, context),

                    ViewProductWidgets().productTitle(snapshot.data!.get('title')),

                    //Review, Add to wishlist and Share Icons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ViewProductWidgets().productReview(),
                        const Spacer(),
                        ViewProductWidgets().addToWishListIcon(context, id),
                        const SizedBox(
                          width: 10,
                        ),
                        ViewProductWidgets().shareProductIcon()
                      ],
                    ),

                    //Price and Discount
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ViewProductWidgets()
                            .productPrice(state.discountCal, discount, price),
                        const SizedBox(
                          width: 10,
                        ),
                        ViewProductWidgets().discountTag(discount)
                      ],
                    ),

                    ViewProductWidgets().productSizes(
                        sizes, context, state.sizeSelected, state.sizeWarning),

                    ViewProductWidgets()
                        .productQuantity(quantityAvailable, state, context),

                    const SizedBox(
                      height: 20,
                    ),

                    ViewProductWidgets().cartBuyButtons(context, quantityAvailable, '', id, state),

                    const SizedBox(
                      height: 20,
                    ),

                    //Description
                    ViewProductWidgets().productDescription(snapshot.data!.get('description')),

                    //Suggested Products
                    //todo: fix this
                    /*UserServices().isUserLoggedIn() ?
                    ShowProductByQueryType(
                        query: ProductQueries().getSuggestedProducts(),
                        title: 'You may also like',
                        listType: 'list'
                    ) :*/
                    ShowProductByQueryType(
                        query: ProductQueries().getPopularProducts(),
                        title: 'You may also like',
                        listType: 'list'
                    )
                  ]
                  ,
                ),
              )
            ],
          );
        } else {
          return ViewProductWidgets().loadingWidget(context);
        }
      },
    );
  }

}
