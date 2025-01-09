import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Product/Bloc/product_states.dart';
import '../../../../Core/Utils/global_variables.dart';
import '../../Bloc/product_bloc.dart';
import '../../Bloc/product_events.dart';
import '../../Utils/variation_card_color.dart';

class VariationsSubWidgets {

  Widget getVariationWarningWidget() {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        color: Colors.red,
      ),
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
    );
  }

  Widget getVariationTitle(ProductState state) {
    return Container(
      margin: const EdgeInsets.only(top: 5, left: 11),
      width: 60,
      child: Text(
        //snapshot.data!.docs[index].id,
        state.variationDocID,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
          overflow: TextOverflow.ellipsis,
        ),
        textAlign: TextAlign.center,
        maxLines: 1,
      ),
    );
  }

  Widget getVariationImageSliderWidget(BuildContext context, ProductState state, AsyncSnapshot<QuerySnapshot> snapshot, int index) {
    return GestureDetector(
      onTap: () {
        final productBloc = BlocProvider.of<ProductBloc>(context);

        productBloc.add(UpdateImageSliderDocID(snapshot.data!.docs[index].id));
        productBloc.add(UpdateVariationSelected(index));
        productBloc.add(UpdateVariationWarning(false));
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
            border: Border.all(
              color: state.variationWarning == false
                  ? variationCardColor(index, state.variationSelected)
                  : Colors.red,
              width: state.variationWarning == false && state.variationSelected == -1 ? 1 : 1.5, //5
            ),
            borderRadius: BorderRadius.circular(3)),
        child: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('/Products/${state.productID}/Variations')
              .doc(state.variationDocID) //place String value of selected variation
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
    );
  }

}

Widget viewProductAltImage(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8),
    child: SizedBox(
      width: MediaQuery.of(context).size.height * 0.55,
      height: MediaQuery.of(context).size.height * 0.45,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: Image.network(
          altImage,
          fit: BoxFit.cover,
        ),
      ),
    ),
  );
}