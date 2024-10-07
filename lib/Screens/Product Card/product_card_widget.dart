import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../Components/custom_image.dart';

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

Widget productDiscount(double productDiscount) {

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
    height: 60,
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

Widget productPrice(double productPrice) {
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

Widget productSoldAmount(double soldAmount) {
  return Text(
    "$soldAmount items sold",
    style: TextStyle(
        fontSize: 13,
        color: Colors.grey.shade700
    ),
  );
}

Widget productButtons() {
  return Row(
    children: [
      Expanded(
        child: SizedBox(
          height: 40,
          child: FilledButton(
              onPressed: () {

              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.orange.withOpacity(0.1)),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    )
                ),
              ),
              child: const Text(
                  'Buy Now',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrangeAccent,
                  fontSize: 13
                ),
              )
          ),
        ),
      ),
      const SizedBox(width: 7,),
      Expanded(
        child: SizedBox(
          height: 40,
          child: FilledButton(
              onPressed: () {

              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.grey.withOpacity(0.3)),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    )
                ),
              ),
              child: Text(
                'Add To Cart',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                    fontSize: 12,
                  overflow: TextOverflow.ellipsis
                ),
              )
          ),
        ),
      ),
    ],
  );
}