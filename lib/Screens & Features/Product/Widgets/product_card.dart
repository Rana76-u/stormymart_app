// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:stormymart_v2/Screens%20&%20Features/Product/Data/onpress_functions.dart';
import '../../../Core/Image/custom_image.dart';

Widget productCard(BuildContext context, String productId, num discount, num discountCal,
    String title, num sold) {

  return GestureDetector(
    onTap: () {
      GoRouter.of(context).push('/product/$productId');
    },
    child: SizedBox(
      width: 300,
      height: 352,
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5)
        ),
        child: Column(
          children: [
            //image & discount
            Stack(
              children: [
                //Pulls image from variation 1's 1st image
                productImage(productId),

                //Discount %Off
                if(discount != 0)...[
                  productDiscount(discount),
                ],
              ],
            ),

            //texts
            Padding(
              padding: const EdgeInsets.only(left: 13, right: 13, top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  productTitle(title),

                  productPrice(discountCal),

                  productSoldAmount(sold),

                  //View Product Button
                  SizedBox(
                    width: double.infinity,
                    child: productButtons(
                        context,
                        'View Product',
                        Colors.orange.withValues(alpha: 0.1),
                        Colors.deepOrangeAccent,
                        () => OnPressFunctions().viewProduct(context, productId)
                    )
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget productImage(String productId, ) {
  return FutureBuilder(
    future: FirebaseFirestore
        .instance
        .collection('/Products/$productId/Variations').get(),
    builder: (context, snapshot) {
      if(snapshot.hasData){
        String docID = snapshot.data!.docs.first.id;
        return FutureBuilder(
          future: FirebaseFirestore
              .instance
              .collection('/Products/$productId/Variations').doc(docID).get(),
          builder: (context, imageSnapshot) {
            if(imageSnapshot.hasData){
              return CustomImage(
                imageSnapshot.data?['images'][0],
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
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
  );
}

Widget productDiscount(num productDiscount) {

  return Positioned(
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
          'Discount: $productDiscount%',
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 11
          ),
        ),
      ),
    ),
  );
}

Widget productTitle(String productTitle) {
  return SizedBox(
    child: Text(
      productTitle,
      style: TextStyle(
          overflow: TextOverflow.ellipsis,
          fontWeight: FontWeight.bold, //w700
          fontSize: 15.5,
          color: Colors.grey.shade800
      ),
    ),
  );
}

Widget productPrice(num productPrice) {
  return Text(
    "Tk ${productPrice.toStringAsFixed(2)}/-",
    maxLines: 1,
    style: const TextStyle(
        fontWeight: FontWeight.bold, //.w900
        fontSize: 14,
        color: Colors.deepOrange
    ),
  );
}

Widget productSoldAmount(num soldAmount) {
  return Text(
    "${soldAmount.toStringAsFixed(0)} items sold",
    style: TextStyle(
        fontSize: 13,
        color: Colors.grey.shade700
    ),
  );
}

Widget productButtons(BuildContext context,
    String buttonText,
    Color buttonColor,
    Color textColor,
    VoidCallback onPressed) {
  return SizedBox(
    //width: double.infinity,
    child: FilledButton(
        onPressed: () {
          onPressed();
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(buttonColor),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              )
          ),
        ),
        child: Text(
            buttonText,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
            fontSize: 12
          ),
        )
    ),
  );
}
