import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:stormymart_v2/Screens/Cart/cart.dart';
import 'package:stormymart_v2/theme/color.dart';
import 'package:get/get.dart';
import 'package:stormymart_v2/utility/globalvariable.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Components/image_viewer.dart';

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

  Widget _appBar() {
    return Padding(
      padding: const EdgeInsets.only(right: 30),
      child: GestureDetector(
        onTap: () {
          if (FirebaseAuth.instance.currentUser != null) {
            //open chat
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("You're Not Logged In.")));
          }
        },
        child: const Icon(
          Icons.mark_chat_unread_rounded,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String id = widget.productId.toString().trim();
    //var shopID = '';

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          _appBar(),
        ],
      ),
      backgroundColor: appBgColor,
      floatingActionButton: floatingButtonWidget(widget.productId.toString().trim()),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
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
                double discountCal = (price / 100) * (100 - discount);
                //var rating = snapshot.data!.get('rating');
                //var sold = snapshot.data!.get('sold');
                var quantityAvailable = snapshot.data!.get('quantityAvailable');
                //shopID = snapshot.data!.get('Shop ID');

                //SIZE LIST
                sizes = snapshot.data!.get('size');

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    imageSliderWidget(id),

                    //Space
                    const SizedBox(height: 5,),

                    variationWidget(id),

                    //Space
                    if (variationWarning == true)
                      const SizedBox(
                        height: 7,
                      ),

                    productInfoWidget(id, discount, discountCal, snapshot.data!, price, quantityAvailable),

                    messageSellerWidget(),

                    //Space At the BOTTOM
                    const SizedBox(height: 70,),
                  ],
                );
              }
              else {
                return loadingWidget();
              }
            },
          ),
        ),
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
      builder:
          (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          List<dynamic> images = snapshot.data!.get('images');
          return images.isNotEmpty
              ? Padding(
            padding: const EdgeInsets.all(0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: ImageSlideshow(
                  width: double.infinity,
                  height:
                  MediaQuery.of(context).size.height *
                      0.42,
                  //0.45
                  initialPage: 0,
                  indicatorColor: Colors.amber,
                  indicatorBackgroundColor: Colors.grey,
                  onPageChanged: (value) {},
                  autoPlayInterval: 7000,
                  isLoop: true,
                  children: List.generate(images.length,
                          (index) {
                        return GestureDetector(
                          onTap: () {
                            Get.to(
                              ImageViewerScreen(
                                imageUrl: images[index],
                              ),
                              transition: Transition.size,
                            );
                          },
                          child: Image.network(
                            images[index],
                            fit: BoxFit.cover,
                          ),
                        );
                      })),
            ),
          )
              : Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height *
                  0.45,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
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

  Widget variationWidget(String id, ) {
    return Container(
      height: variationWarning ? 140 : 116,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: variationWarning
            ? Colors.red.withOpacity(0.25)
            : appBgColor,
      ),
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Name
                    Container(
                      margin: const EdgeInsets.only(
                          top: 5, left: 11),
                      width: 70,
                      child: Text(
                        //snapshot.data!.docs[index].id,
                        variationDocID,
                        style: const TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis),
                        maxLines: 1,
                      ),
                    ),
                    //image
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          variationSelected = index;
                          imageSliderDocID =
                              snapshot.data!.docs[index].id;
                          variationWarning = false;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                            top: 5,
                            left: 10,
                            right: 15,
                            bottom: 15),
                        width: 70,
                        //200
                        height: 70,
                        //136.5

                        decoration: BoxDecoration(
                            border: Border.all(
                              color: variationWarning == false
                                  ? _variationCardColor(index)
                                  : Colors.red,
                              width: 2, //5
                            ),
                            borderRadius:
                            BorderRadius.circular(10)),
                        child: FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection(
                              '/Products/$id/Variations')
                              .doc(
                              variationDocID) //place String value of selected variation
                              .get()
                              .then((value) => value),
                          builder: (context,
                              AsyncSnapshot<DocumentSnapshot>
                              snapshot) {
                            if (snapshot.hasData) {
                              List<dynamic> images =
                              snapshot.data!.get('images');
                              return ImageSlideshow(
                                  initialPage: 0,
                                  indicatorColor: Colors.amber,
                                  indicatorBackgroundColor:
                                  Colors.grey,
                                  onPageChanged: (value) {},
                                  autoPlayInterval: 3500,
                                  isLoop: true,
                                  children: List.generate(
                                      images.length, (index) {
                                    return ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(
                                          8),
                                      child: Image.network(
                                        images[index],
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  }));
                            } else {
                              return const Center(
                                child:
                                CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    if (variationWarning == true)
                      Padding(
                        padding:
                        const EdgeInsets.only(left: 15),
                        child: Container(
                          color: Colors.red,
                          alignment: Alignment.center,
                          child: const Padding(
                            padding: EdgeInsets.only(
                                left: 4, right: 4),
                            child: Text(
                              'Please select a variation',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontFamily: 'Urbanist',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
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
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Discount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Discount
                if (discount == 0.0) ...[
                  const SizedBox(),
                ]
                else ...[
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

                //wishlist
                GestureDetector(
                  onTap: () async {
                    final messenger =
                    ScaffoldMessenger.of(context);
                    await FirebaseFirestore.instance
                        .collection('/userData')
                        .doc(FirebaseAuth
                        .instance.currentUser!.uid)
                        .update({
                      'wishlist': FieldValue.arrayUnion([id])
                    });

                    messenger.showSnackBar(const SnackBar(
                        content:
                        Text('Item added to Wishlist')));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(7),
                      child: Text(
                        '+ wishlist',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            //Title
            Padding(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 5, left: 0, right: 5),
              child: Text(
                snapshot.get('title'),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.grey.shade700),
              ),
            ),

            //Price
            Row(
              children: [
                Text(
                  "TK ${discountCal.toStringAsFixed(0)}/-",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 21.5,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                if (discount == 0.0) ...[
                  const SizedBox(),
                ] else ...[
                  Text(
                    "of ${price.toString()}/-",
                    style: const TextStyle(
                      //fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.lineThrough),
                  ),
                ]
              ],
            ),

            // Description
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                snapshot.get('description'),
                style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600),
              ),
            ),

            //Show Sizes
            if (sizes.isEmpty) ...[
              const SizedBox()
            ] else ...[
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
                            borderRadius: BorderRadius.circular(
                                100)), //CircleBorder()
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 10,
                                bottom: 10,
                                right: 15,
                                left: 15),
                            child: Text(
                              sizes[index],
                              style: TextStyle(
                                color: sizeSelected == index ||
                                    sizeWarning
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

            // Quantity
            if (quantityAvailable == 0) ...[
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  '*Sold Out',
                  style: TextStyle(
                      fontSize: 22,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.bold,
                      color: Colors.amber),
                ),
              ),
            ]
            else ...[
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
                width: MediaQuery.of(context).size.width * 0.41,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
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
      ),
    );
  }

  Widget messageSellerWidget() {
    return GestureDetector(
      onTap: () async {
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
      child: Container(
          height: 50,
          width: double.infinity,
          color: const Color(0xFFFAB416),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.messenger_rounded,
                color: Colors.white,
              ),
              SizedBox(width: 10,),
              Text(
                "Message Seller",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              )
            ],
          )
      ),
    );
  }

  Widget loadingWidget() {
    return Center(
      child: Column(
        children: [
          //Do not remove this, otherwise it causes continues rendering
          SizedBox(height: MediaQuery.of(context).size.height * 0.45,),

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
        child: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('Products')
              .doc(id)
              .get()
              .then((value) => value),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData) {
              var quantityAvailable = snapshot.data!.get('quantityAvailable');
              var shopID = snapshot.data!.get('Shop ID');

              return FittedBox(
                child: FloatingActionButton.extended(
                  onPressed: () {
                    addToCartFunction(quantityAvailable, shopID, id);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  label: const Text(
                    'Add To Cart',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  icon: const Icon(Icons.shopping_cart_rounded),
                ),
              );
            }
            else if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: const LinearProgressIndicator(),
              );
            }
            else {
              return const Text('Error Loading');
            }
          },
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
      messenger.showSnackBar(const SnackBar(
          content: Text('Product Got Sold Out')));
    }
    else if (quantity > quantityAvailable) {
      messenger.showSnackBar( SnackBar(
          content: Text("Only $quantityAvailable items available")));
    }
    else {
      if (sizeSelected == -1 && sizes.isNotEmpty) {
        setState(() {
          sizeWarning = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Select Size')));
      }
      else if (variationSelected == -1) {
        setState(() {
          variationWarning = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Select Variant')));
      }
      else {
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
            'quantity': quantity
          });
        }
        //user Not logged in
        else {
          //add item to temporary cart
          tempProductIds.add(id);
          tempSizes.add(sizeSelected == -1 ? 'not applicable' : sizes[sizeSelected].toString());
          tempVariants.add(imageSliderDocID);
          tempQuantities.add(quantity);
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
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: mediaQuery.size.width * 0.4,
                  child: const Text(
                    'Item added into the cart.',
                    style: TextStyle(
                        overflow: TextOverflow.clip),
                  ),
                ),
                if (mounted) ...[
                  SizedBox(
                    width: mediaQuery.size.width * 0.4,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(20)),
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                          builder: (context) => const Cart(),
                        ));
                      },
                      child: const Text(
                        'Open Cart',
                        style: TextStyle(
                            fontFamily: 'Urbanist',
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
