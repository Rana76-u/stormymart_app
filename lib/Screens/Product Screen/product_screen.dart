import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stormymart_v2/Blocks/Cart%20Bloc/cart_bloc.dart';
import 'package:stormymart_v2/Screens/Cart/cart.dart';
import 'package:stormymart_v2/theme/color.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Blocks/Cart Bloc/cart_events.dart';
import '../../Blocks/Home Bloc/home_bloc.dart';
import '../../Blocks/Home Bloc/home_state.dart';
import '../../ViewModels/open_photo.dart';
import '../Home/Footer/home_footer.dart';
import '../Home/Home AppBar/appbar_widgets.dart';

class ProductScreen extends StatefulWidget {
  final String productId;

  const ProductScreen({super.key, required this.productId});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  String variationDocID = '';
  String imageSliderDocID = '';
  int quantity = 1;
  int variationCount = 0;
  int clickedIndex = 0;
  List<dynamic> sizes = [];
  double discountCal = 0;

  int sizeSelected = -1;
  int variationSelected = -1;

  bool variationWarning = false;
  bool sizeWarning = false;

  final ScrollController scrollController = ScrollController();

  void checkLength() async {
    String id = widget.productId.toString().trim();
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('/Products/$id/Variations')
        .get();

    variationCount = snapshot.docs.length;
    imageSliderDocID = snapshot.docs.first.id;
  }

  @override
  void initState() {
    super.initState();
    checkLength();
  }

  Color _cardColor(int i) {
    if (sizeSelected == i) {
      return Colors.green;
    } else {
      return Colors.white;
    }
  }

  Color _variationCardColor(int i) {
    if (variationSelected == i) {
      return Colors.green;
    } else {
      return Colors.blueGrey;
    }
  }


  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.only(left: 10, right: 10);
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: appBgColor,
        floatingActionButton: floatingButtonWidget(widget.productId.toString().trim()),
        //drawer: _drawer(context),
        body: CustomScrollView( //RefreshIndicator just above here
          slivers: <Widget>[
            BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                return homeAppbar(context, state);
              },
            ),

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

            //build footer
            SliverToBoxAdapter(
              child: homeFooter(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    String id = widget.productId.toString().trim();

    return Padding(
      padding: MediaQuery.of(context).size.width <= 600 ?
      const EdgeInsets.symmetric(horizontal: 15)
          :
      MediaQuery.of(context).size.width <= 1565 ?
      EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.065)
          :
      EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.15),
      child: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('Products')
            .doc(id)
            .get()
            .then((value) => value),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            var price = snapshot.data!.get('price');
            var discount = snapshot.data!.get('discount');
            discountCal = (price / 100) * (100 - discount);
            //var rating = snapshot.data!.get('rating');
            //var sold = snapshot.data!.get('sold');
            var quantityAvailable = snapshot.data!.get('quantityAvailable');
            //shopID = snapshot.data!.get('Shop ID');

            //SIZE LIST
            sizes = snapshot.data!.get('size');

            return Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      variationWidget(id),

                      //Space
                      const SizedBox(
                        width: 20,
                      ),
                      /*if (variationWarning == true)
                      const SizedBox(
                        width: 7,
                      ),*/

                      imageSliderWidget(id),

                      //Space
                      const SizedBox(
                        width: 30,
                      ),

                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            productInfoWidget(id, discount, discountCal, snapshot.data!,
                                price, quantityAvailable),

                            Row(
                              children: [
                                buttons("Add To Cart", Colors.grey.withOpacity(0.5), Colors.black, quantityAvailable, id, id),
                                const SizedBox(width: 20,),
                                buttons("Buy Now", Colors.deepOrangeAccent, Colors.white, quantityAvailable, id, id),
                              ],
                            ),
                            const SizedBox(height: 20,),
                            //buttons("Message Seller", const Color(0xFFFAB416), Colors.white, quantityAvailable, id, id),
                          ],
                        ),
                      )
                    ],
                  ),
                  const Divider(height: 25,),
                  const SizedBox(height: 35,),
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
                    child: Divider(color: Colors.deepOrange, thickness: 2,),
                  ),
                  //Description Text
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      snapshot.data!.get('description'),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return loadingWidget();
          }
        },
      ),
    );
  }

  Widget imageSliderWidget(String id) {
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
              ? Padding(
                  padding: const EdgeInsets.all(0),
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1, //5
                          ),
                          borderRadius: BorderRadius.circular(3)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: ImageSlideshow(
                          width: MediaQuery.of(context).size.height * 0.55,
                          height: MediaQuery.of(context).size.height * 0.5,
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
                          })
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.height * 0.55,
                    height: MediaQuery.of(context).size.height * 0.45,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: Image.network(
                        'https://cdn.dribbble.com/users/256646/screenshots/17751098/media/768417cc4f382d6171053ad620bc3c3b.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget variationWidget(String id) {
    return Container(
      height: variationWarning ? MediaQuery.of(context).size.height*0.5 + 25 : MediaQuery.of(context).size.height*0.5, //116
      width: 100,//double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: variationWarning ? Colors.red.withOpacity(0.25) : appBgColor,
      ),
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.vertical,
        itemCount: variationCount,
        itemBuilder: (context, index) {
          return FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('/Products/$id/Variations')
                .get()
                .then((value) => value),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                variationDocID = snapshot.data!.docs[index].id;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (variationWarning == true && index == 0)
                      Container(
                        color: Colors.red,
                        alignment: Alignment.center,
                        child: const Padding(
                          padding: EdgeInsets.only(left: 4, right: 4),
                          child: Text(
                            'Please Select A Variant',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,

                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    //image
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          variationSelected = index;
                          imageSliderDocID = snapshot.data!.docs[index].id;
                          variationWarning = false;
                        });
                      },
                      child: Container(
                        /*margin: const EdgeInsets.only(
                            top: 5, left: 10, right: 15, bottom: 15),*/
                        width: 100, //200
                        height: 100, //136.5
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: variationWarning == false
                                  ? _variationCardColor(index)
                                  : Colors.red,
                              width: 1, //5
                            ),
                            borderRadius: BorderRadius.circular(3)),
                        child: FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('/Products/$id/Variations')
                              .doc(
                                  variationDocID) //place String value of selected variation
                              .get()
                              .then((value) => value),
                          builder: (context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.hasData) {
                              List<dynamic> images =
                                  snapshot.data!.get('images');
                              return ImageSlideshow(
                                  initialPage: 0,
                                  indicatorColor: Colors.amber,
                                  indicatorBackgroundColor: Colors.grey,
                                  onPageChanged: (value) {},
                                  autoPlayInterval: 3500,
                                  isLoop: true,
                                  children:
                                      List.generate(images.length, (index) {
                                    return Image.network(
                                      images[index],
                                      fit: BoxFit.cover,
                                    );
                                  }));
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    //Name
                    Container(
                      margin: const EdgeInsets.only(top: 5, left: 11),
                      width: 70,
                      child: Text(
                        //snapshot.data!.docs[index].id,
                        variationDocID,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            overflow: TextOverflow.ellipsis,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                      ),
                    ),
                  ],
                );
              } else {
                return const Text(
                  'No Variations',
                  style: TextStyle(color: Colors.grey),
                );
              }
            },
          );
        },
      ),
    );
  }

  Widget productInfoWidget(String id, double discount, double discountCal,
      DocumentSnapshot snapshot, double price, double quantityAvailable) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Discount, Wishlist, Share
          Row(
            children: [
              //Discount
              if (discount == 0.0) ...[
                const SizedBox(),
              ] else ...[
                Container(
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
                ),
              ],

              const Spacer(),

              //wishlist
              GestureDetector(
                onTap: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  await FirebaseFirestore.instance
                      .collection('/userData')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .update({
                    'wishlist': FieldValue.arrayUnion([id])
                  });

                  messenger.showSnackBar(const SnackBar(
                      content: Text('Item added to Wishlist')));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(15),
                    child: Icon(Icons.favorite_border_rounded, color: Colors.red,),
                  ),
                ),
              ),

              const SizedBox(width: 10,),

              //Share
              GestureDetector(
                onTap: () async {
                  await Share.share('https://www.stormymart.com/#/product/$id');
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(15),
                    child: Icon(Icons.screen_share_rounded, color: Colors.blueGrey,),
                  ),
                ),
              ),
            ],
          ),

          //Title
          Padding(
            padding:
                const EdgeInsets.only(top: 20),
            child: Text(
              snapshot.get('title'),
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
              ),
            ),
          ),

          const SizedBox(height: 20,),

          //Review
          const Text(
              'No Review Yet',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                fontSize: 12
              )
          ),

          const SizedBox(height: 20,),

          //Price
          Row(
            children: [
              Text(
                "TK ${discountCal.toStringAsFixed(0)}/-",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.deepOrangeAccent
                ),
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
                      decoration: TextDecoration.lineThrough),
                ),
              ]
            ],
          ),
          const SizedBox(height: 20,),

          const SizedBox(height: 20,),

          //Show Sizes
          if (sizes.isEmpty) ...[
            const SizedBox()
          ] else ...[
            const Text(
              'Select Size',
              style: TextStyle(
                fontWeight: FontWeight.bold
              )
            ),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ListView.builder(
                itemCount: sizes.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        sizeSelected = index;
                        sizeWarning = false;
                      });
                    },
                    child: Card(
                      color: sizeWarning == false
                          ? _cardColor(index)
                          : Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(100)), //CircleBorder()
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, right: 15, left: 15),
                          child: Text(
                            sizes[index],
                            style: TextStyle(
                              color: sizeSelected == index || sizeWarning
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
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

          const SizedBox(height: 20,),

          // Quantity
          if (quantityAvailable == 0) ...[
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                '*Sold Out',
                style: TextStyle(
                    fontSize: 22,

                    fontWeight: FontWeight.bold,
                    color: Colors.amber),
              ),
            ),
          ] else ...[
            const Padding(
              padding: EdgeInsets.only(top: 10, bottom: 5),
              child: Text(
                'Select Quantity',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 39, //42
              width: 150,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        // Decrement quantity
                        setState(() {
                          if (quantity != 1) {
                            quantity--;
                          }
                        });
                      },
                    ),
                    Text(quantity.toString()),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        // Increment quantity
                        setState(() {
                          quantity++;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget buttons(String text, Color bgColor, Color textColor, quantityAvailable, String shopID, String id) {
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          addToCartFunction(quantityAvailable, shopID, id);
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

  Widget loadingWidget() {
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

  Widget floatingButtonWidget(String id) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: SizedBox(
        height: 80,
        width: 130,
        child: FittedBox(
          child: FloatingActionButton.extended(
            onPressed: () async {
              var baseUrl = 'https://www.stormymart.com/#/product/';
              var productId = widget.productId;
              var messengerLink =
                  'https://m.me/stormymart?text=${Uri.encodeComponent(baseUrl + productId)}';
              if (await canLaunchUrl(Uri.parse(messengerLink))) {
                await launchUrl(Uri.parse(messengerLink));
              } else {
                throw 'Could not launch $messengerLink';
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

  void addToCartFunction(double quantityAvailable, String shopID, String id) async {
    final messenger = ScaffoldMessenger.of(context);
    final mediaQuery = MediaQuery.of(context);

    setState(() {
      sizeWarning = false;
      variationWarning = false;
    });
    if (quantityAvailable == 0) {
      messenger
          .showSnackBar(const SnackBar(content: Text('Product Got Sold Out')));
    } else if (quantity > quantityAvailable) {
      messenger.showSnackBar(
          SnackBar(content: Text("Only $quantityAvailable items available")));
    } else {
      if (sizeSelected == -1 && sizes.isNotEmpty) {
        setState(() {
          sizeWarning = true;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Select Size')));
      } else if (variationSelected == -1) {
        setState(() {
          variationWarning = true;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Select Variant')));
      } else {
        //user logged in
        if (FirebaseAuth.instance.currentUser != null) {
          String uid = FirebaseAuth.instance.currentUser!.uid;

          await FirebaseFirestore.instance
              .collection('userData/$uid/Cart/')
              .doc()
              .set({
            //'1': FieldValue.arrayUnion(valuesToAdd)
            'Shop ID': shopID,
            'id': id,
            'selectedSize': sizeSelected == -1
                ? 'not applicable'
                : sizes[sizeSelected].toString(),
            'variant': imageSliderDocID,
            'quantity': quantity,
          });
        }
        //user Not logged in
        else {
          BlocProvider.of<CartBloc>(context).add(AddItemEvent(
              id: id,
              price: discountCal,
              size: sizeSelected == -1
                  ? 'not applicable'
                  : sizes[sizeSelected].toString(),
              variant: imageSliderDocID,
              quantity: quantity)
          );
        }

        //notify
        messenger.showSnackBar(SnackBar(
          content: GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const Cart(),
              ));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: mediaQuery.size.width * 0.4,
                  child: const Text(
                    'Item added into the cart.',
                    style: TextStyle(overflow: TextOverflow.clip),
                  ),
                ),
                if (mounted) ...[
                  SizedBox(
                    width: mediaQuery.size.width * 0.4,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const Cart(),
                        ));
                        GoRouter.of(context).go('/cart');
                      },
                      child: const Text(
                        'Open Cart',
                        style: TextStyle(
                            
                            fontWeight: FontWeight.bold,
                            fontSize: 14.5),
                      ),
                    ),
                  )
                ]
              ],
            ),
          ),
          duration: const Duration(seconds: 3),
        ));
      }
    }
  }
}
