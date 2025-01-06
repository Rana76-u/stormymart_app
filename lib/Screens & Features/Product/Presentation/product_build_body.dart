import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Bloc/product_bloc.dart';
import '../Bloc/product_events.dart';
import '../Bloc/product_states.dart';
import '../Widgets/View Product/view_product_widgets.dart';

Widget productBuildBody(BuildContext context, ProductState state, String id) {
  final productBloc = BlocProvider.of<ProductBloc>(context);

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

                  Row(
                    children: [
                      ViewProductWidgets().buttons(
                          "Add To Cart",
                          Colors.grey.withValues(alpha: 0.5),
                          Colors.black,
                          quantityAvailable,
                          id,
                          id,
                          context,
                          state),
                      const SizedBox(
                        width: 20,
                      ),
                      ViewProductWidgets().buttons("Buy Now", Colors.deepOrangeAccent,
                          Colors.white, quantityAvailable, id, id, context, state),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //Description Heading
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrangeAccent,
                    ),
                  ),
                  //Orange Divider
                  const SizedBox(
                    width: 80,
                    child: Divider(
                      color: Colors.deepOrange,
                      thickness: 2,
                    ),
                  ),
                  //Description Text
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      snapshot.data!.get('description'),
                    ),
                  ),

                  //You may also like
                  const Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Text(
                      'You may also like',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  //todo: suggestedProducts(snapshot.data!.id)
                ],
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
