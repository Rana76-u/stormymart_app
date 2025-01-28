// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:stormymart_v2/Core/Utils/core_progress_bars.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Product/Bloc/product_states.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Product/Widgets/View%20Product/view_product_widget_utils.dart';
import '../../../../Core/Image/open_photo.dart';
import '../../../../Core/theme/color.dart';
import '../../../User/Data/user_hive.dart';
import '../../Bloc/product_bloc.dart';
import '../../Bloc/product_events.dart';
import '../../Data/onpress_functions.dart';
import '../../Utils/size_card_color.dart';
import '../product_card.dart';

class ViewProductWidgets {
  Widget blurEffect() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.35),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget getImageSliderWidget(String id, String imageSliderDocID) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('Products/$id/Variations')
          .doc(imageSliderDocID)
          .get()
          .then((value) => value),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          List<dynamic> images = snapshot.data!.get('images');
          return images.isNotEmpty
              ? ImageSlideshow(
                  width: double
                      .infinity, //MediaQuery.of(context).size.height * 0.55,
                  height: MediaQuery.of(context).size.height * 0.55,
                  initialPage: 0,
                  indicatorColor: Colors.amber,
                  indicatorBackgroundColor: Colors.grey,
                  onPageChanged: (value) {},
                  autoPlayInterval: 7000,
                  isLoop: true,
                  children: List.generate(images.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        OpenPhoto().openPhotoGallery(context, index, images);
                      },
                      child: Image.network(
                        images[index],
                        fit: BoxFit.cover,
                      ),
                    );
                  }))
              : viewProductAltImage(context);
        } else {
          return centeredCircularProgress();
        }
      },
    );
  }

  Widget variationWidget(ProductState state, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 5),
      child: Container(
        height: state.variationWarning == true ? 115 : 95,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: state.variationWarning
              ? Colors.red.withValues(alpha: 0.25)
              : appBgColor,
        ),
        child: Column(
          children: [
            if (state.variationWarning == true)
              VariationsSubWidgets().getVariationWarningWidget(),

            SizedBox(
              height: 95,
              child: ListView.builder(
                controller: state.scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: state.variationCount,
                itemBuilder: (context, index) {
                  return FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('/Products/${state.productID}/Variations')
                        .get()
                        .then((value) => value),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        state.variationDocID = snapshot.data!.docs[index].id;
                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                            children: [
                              //image
                              VariationsSubWidgets().getVariationImageSliderWidget(
                                  context, state, snapshot, index),
                              //Name
                              VariationsSubWidgets().getVariationTitle(state),
                            ],
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget productTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
      ),
    );
  }

  Widget productReview() {
    return const Text('No Review Yet',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12));
  }

  Widget addToWishListIcon(BuildContext context, String id) {
    return GestureDetector(
      onTap: () async {
        final messenger = ScaffoldMessenger.of(context);
        await FirebaseFirestore.instance
            .collection('/userData')
            .doc(UserHive().getUserUid())
            .update({
          'wishlist': FieldValue.arrayUnion([id])
        });

        messenger.showSnackBar(
            const SnackBar(content: Text('Item added to Wishlist')));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Padding(
          padding: EdgeInsets.all(8),
          child: Icon(
            Icons.favorite_border_rounded,
            color: Colors.red,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget shareProductIcon() {
    return GestureDetector(
      onTap: () async {
        //await Share.share('https://www.stormymart.com/#/product/$id');
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Padding(
          padding: EdgeInsets.all(8),
          child: Icon(
            Icons.screen_share_rounded,
            color: Colors.blueGrey,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget productPrice(double discountCal, num discount, num price) {
    return Row(
      children: [
        Text(
          "TK ${discountCal.toStringAsFixed(0)}/-",
          style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 18,
              color: Colors.deepOrangeAccent),
        ),
        const SizedBox(
          width: 10,
        ),
        if (discount == 0.0) ...[
          const SizedBox(),
        ] else ...[
          Text(
            "Tk ${price.toString()}/-",
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.lineThrough),
          ),
        ]
      ],
    );
  }

  Widget discountTag(num discount) {
    return (discount == 0.0)
        ? const SizedBox()
        : Container(
            decoration: BoxDecoration(
              color: Colors.red.shade800,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                'Discount: $discount%',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13),
              ),
            ),
          );
  }

  Widget productSizes(List sizes, BuildContext context, int sizeSelected, bool sizeWarning) {
    final productBloc = BlocProvider.of<ProductBloc>(context);

    return (sizes.isEmpty) ? const SizedBox() :
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select Size',
            style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(
          height: 35,
          width: double.infinity,
          child: ListView.builder(
            itemCount: sizes.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  productBloc.add(UpdateSizeSelected(index));
                  productBloc.add(UpdateSizeWarning(false));
                },
                child: Card(
                  color: sizeWarning == false
                      ? sizeCardColor(index, sizeSelected)
                      : Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(100)), //CircleBorder()
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      child: Text(
                        sizes[index],
                        style: TextStyle(
                          color: sizeSelected == index || sizeWarning
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  Widget productQuantity(num quantityAvailable, ProductState state, BuildContext context) {
    final productBloc = BlocProvider.of<ProductBloc>(context);

    return (quantityAvailable == 0) ?
    const Padding(
      padding: EdgeInsets.all(10),
      child: Text(
        '*Sold Out',
        style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.amber),
      ),
    )
    :
    Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 10, bottom: 5, right: 10),
          child: Text(
            'Select Quantity',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12
            ),
          ),
        ),
        SizedBox(
          height: 29, //42
          width: 120,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, size: 15,),
                  onPressed: () {
                    // Decrement quantity
                    if (state.quantity != 1) {
                      productBloc.add(UpdateQuantity(state.quantity - 1));
                    }
                  },
                ),
                Text(state.quantity.toString(), style: const TextStyle(fontSize: 12)),
                IconButton(
                  icon: const Icon(Icons.add, size: 15,),
                  onPressed: () {
                    // Increment quantity
                    productBloc.add(UpdateQuantity(state.quantity + 1));
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget productDescription(String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            description,
          ),
        ),
      ],
    );
  }

  Widget cartBuyButtons(BuildContext context,
      num quantityAvailable, String shopID, String id, ProductState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.45,
            child: productButtons(
                context,
                'Add To Cart',
                Colors.orange.withValues(alpha: 0.1),
                Colors.deepOrangeAccent,
                () => OnPressFunctions().addToCartFunction('Add To Cart',quantityAvailable, shopID, id, context, state))
        ),
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.45,
            child: productButtons(context,
                'Buy Now',
                Colors.grey.withValues(alpha: 0.1),
                Colors.grey.shade900,
                () {
                  OnPressFunctions().addToCartFunction('Buy Now', quantityAvailable, shopID, id, context, state);
                },
            )
        ),
      ],
    );
  }

  Widget buttons(String text, Color bgColor, Color textColor, quantityAvailable,
      String shopID, String id, BuildContext context, ProductState state) {
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          //addToCartFunction(quantityAvailable, shopID, id, context, state);
        },
        child: Container(
            height: 50,
            color: bgColor,
            child: Center(
              child: Text(
                text,
                style: TextStyle(color: textColor),
              ),
            )),
      ),
    );
  }

  Widget loadingWidget(BuildContext context) {
    return Center(
      child: Column(
        children: [
          //Do not remove this, otherwise it causes continues rendering
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.45,
          ),

          const CircularProgressIndicator(),
        ],
      ),
    );
  }

  Widget floatingButtonWidget(
    String id, BuildContext context
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: SizedBox(
        height: 80,
        width: 130,
        child: FittedBox(
          child: FloatingActionButton.extended(
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              var baseUrl = 'https://stormymart-43ea8.firebaseapp.com/#/product/';
              var messengerLink =
                  'https://m.me/stormymart?text=${Uri.encodeComponent(baseUrl + id)}';

              try {
                if (await canLaunchUrl(Uri.parse(messengerLink))) {
                  await launchUrl(Uri.parse(messengerLink), mode: LaunchMode.externalApplication);
                } else {
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Could not launch Messenger. Please check your app.')),
                  );
                }
              } catch (e) {
                debugPrint('Error launching URL: $e');
                messenger.showSnackBar(
                  const SnackBar(content: Text('An unexpected error occurred.')),
                );
              }
            },

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0),
            ),
            label: const Text(
              'Message Seller',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            icon: const Icon(Icons.messenger),
          ),
        ),
      ),
    );
  }
}
