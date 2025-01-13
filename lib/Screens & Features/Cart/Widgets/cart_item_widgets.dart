import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Cart/Bloc/cart_states.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Cart/Widgets/cart_widgets.dart';
import 'package:transparent_image/transparent_image.dart';

import '../Bloc/cart_bloc.dart';
import '../Bloc/cart_events.dart';
import '../Util/item_util.dart';

class CartItemWidgets {

  Widget checkBox(BuildContext context, CartState state, int index) {

    final provider = BlocProvider.of<CartBloc>(context);

    return Checkbox(
      value: state.checkList.isNotEmpty
          ? state.checkList[index]
          : false,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      /*shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),*/
      checkColor: Colors.white,
      activeColor: Colors.deepOrange,
      side: WidgetStateBorderSide.resolveWith(
            (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return const BorderSide(width: 2, color: Colors.deepOrange);
          }
          return const BorderSide(width: 1, color: Colors.deepOrangeAccent);
        },
      ),
      onChanged: (value) {
        provider.add(UpdateCheckList(index: index, isChecked: !state.checkList[index]));
      },
    );
  }

  Widget image(String productId, String variant, ) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('/Products/$productId/Variations')
          .doc(variant)
          .get(),
      builder: (context, imageSnapshot) {
        if (imageSnapshot.hasData) {
          return GestureDetector(
            onTap: () {
              GoRouter.of(context).go('/product/$productId');
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 0, right: 8),
              child: Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: FadeInImage.memoryNetwork(
                    image: imageSnapshot.data!.get('images')[0],
                    placeholder: kTransparentImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        }
        else if (imageSnapshot.connectionState == ConnectionState.waiting) {
          return ItemUtil().loadingWidget(context, 0.4);
        }
        else {
          return ItemUtil().errorWidget(context, 'Error Loading Data');
        }
      },
    );
  }

  Widget texts(BuildContext context, CartState state, int index,
      String title, num priceAfterDiscount, String size, String variant) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Title, Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Title
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis
                  ),
                ),
              ),

              //Space
              const SizedBox(width: 30),

              //Price
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Text(
                  '৳ $priceAfterDiscount',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 19,
                      color: Colors.deepOrangeAccent,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ],
          ),

          // Size, Variant & Quantity
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Size
                    Text(
                      'Size: $size',
                      style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black54,
                          overflow: TextOverflow.ellipsis),
                    ),

                    //Variant
                    Text(
                      'Variant: $variant',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 11, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: CartWidgets().quantitySelector(context, state, index)
              )
            ],
          ),
        ],
      ),
    );
  }

}