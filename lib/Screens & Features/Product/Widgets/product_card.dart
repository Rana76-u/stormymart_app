import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../Components/custom_image.dart';

Widget productCard(BuildContext context, String productId, double discount, double discountCal,
    String title, double sold) {
  return GestureDetector(
    onTap: () {
      GoRouter.of(context).go('/product/$productId');
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

                  //Title
                  productTitle(title),

                  //const SizedBox(height: 10,),
                  //price
                  productPrice(discountCal),

                  //const SizedBox(height: 15,),

                  productSoldAmount(sold),

                  //const SizedBox(height: 15,),

                  productButtons(context, productId)
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
    "${soldAmount.toStringAsFixed(0)} items sold",
    style: TextStyle(
        fontSize: 13,
        color: Colors.grey.shade700
    ),
  );
}

Widget productButtons(BuildContext context, String productId) {
  return SizedBox(
    width: double.infinity,
    child: FilledButton(
        onPressed: () {
          GoRouter.of(context).go('/product/$productId');
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.orange.withValues(alpha: 0.1)),
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
            fontSize: 12
          ),
        )
    ),
  );
}

/*const SizedBox(width: 5,),
      Expanded(
        child: FilledButton(
            onPressed: () {
              GoRouter.of(context).go('/product/$productId');
              //BlocProvider.of<HomeBloc>(context).add(UpdateCartValueEvent(cartValue: state.cartValue + 1));
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.grey.withValues(alpha: 0.3)),
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
                overflow: TextOverflow.clip
              ),
            )
        ),
      ),*/