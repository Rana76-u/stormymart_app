import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../Blocks/Cart Bloc/cart_bloc.dart';
import '../../Blocks/Cart Bloc/cart_events.dart';
import '../../ViewModels/cart_viewmodel.dart';

class ItemUtil {

  Widget containerWidget(double? width) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Container(
        height: 10,
        width: width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.shade200
        ),
      ),
    );
  }

  Widget shimmerLoading(BuildContext context) {
    return Card(
      elevation: 0,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade200,
        highlightColor: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //Checkbox
            Checkbox(
              value: false,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              onChanged: (value) {},
            ),

            //Image
            Padding(
              padding: const EdgeInsets.only(right: 8, top: 5, bottom: 5),
              child: Container(
                width: 95,
                height: 95, //137 127 120 124
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.shade200
                ),
              ),
            ),

            //Texts
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.55 -
                      20, //200, 0.45
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Title
                      containerWidget(null),

                      //Price
                      containerWidget(50),

                      //Size
                      containerWidget(90),

                      //Variant
                      containerWidget(100),

                      //Quantity
                      containerWidget(80),

                    ],
                  ),
                ),
              ),
            ),

            //Delete
            const Padding(
              padding: EdgeInsets.only(right: 10),
              child: SizedBox(
                child: Icon(
                  Icons.delete_forever,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget loadingWidget(BuildContext context, double size) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * size,
        height: 1,
        child: const LinearProgressIndicator(),
      ),
    );
  }

  Widget errorWidget(BuildContext context, String text) {
    return Center(
      child: Text(text),
    );
  }

  Widget cartItemNotAvailableWidget(BuildContext context, String cartItemDocID, double? price, int index) {

    final user = FirebaseAuth.instance.currentUser;

    return Card(
      elevation: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //Checkbox
          Checkbox(
            value: false,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)),
            onChanged: (value) {},
          ),

          //Error Text
          errorWidget(context, "Item Is Not Listed Anymore"),

          //Delete
          deleteItemButton(context, user, cartItemDocID, price, index)
        ],
      ),
    );
  }

  Widget deleteItemButton(BuildContext context, final user, String? cartItemDocID,
      double? priceAfterDiscount, int? index) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Please Confirm'),
                content: const Text(
                    'Are you sure you want to delete this item?'),
                actions: [
                  // The "Yes" button
                  TextButton(
                      onPressed: () {
                        if(user != null){
                          CartViewModel().deleteDocument(
                              context, cartItemDocID!, priceAfterDiscount, index!
                          );
                        }

                        BlocProvider.of<CartBloc>(context).add(DeleteItemEvent(index: index!));
                        Navigator.of(context).pop();
                      },
                      child: const Text('Yes')),
                  TextButton(
                      onPressed: () {
                        // Close the dialog
                        Navigator.of(context).pop();
                      },
                      child: const Text('No'))
                ],
              );
            },
          );
        },
        child: const SizedBox(
          child: Icon(
            Icons.delete_forever,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
