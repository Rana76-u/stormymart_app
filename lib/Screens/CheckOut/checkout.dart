import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stormymart_v2/Blocks/CheckOut%20Bloc/checkout_bloc.dart';
import 'package:stormymart_v2/Blocks/CheckOut%20Bloc/checkout_events.dart';
import 'package:stormymart_v2/Blocks/CheckOut%20Bloc/checkout_state.dart';
import 'package:stormymart_v2/ViewModels/checkout_viewmodel.dart';
import 'package:transparent_image/transparent_image.dart';
import '../Cart/item_util.dart';

class CheckOut extends StatelessWidget {
  const CheckOut({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = BlocProvider.of<CheckoutBloc>(context);
    final user = FirebaseAuth.instance.currentUser;

    TextEditingController nameController = TextEditingController();
    TextEditingController phnNumberController = TextEditingController();
    TextEditingController addressController = TextEditingController();
    TextEditingController divisionController = TextEditingController();
    TextEditingController promoCodeController = TextEditingController();

    if(user != null) {
      provider.add(LoadUserDataEvent(uid: user.uid));
    }

    return BlocConsumer<CheckoutBloc, CheckOutState>(
      listener: (context, state) {},
      builder: (context, state) {
        nameController.text = state.userName;
        phnNumberController.text = state.phoneNumber;
        addressController.text = state.selectedAddress;
        divisionController.text = state.selectedDivision;

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: const Text(
              'Checkout',
              style: TextStyle(
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          body: state.isLoading ?
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width*0.45,
              child: const LinearProgressIndicator(),
            ),
          ) :
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  titlesWidget('Contact Info'),

                  textBox(37, double.infinity, nameController, "Full Name", const Icon(Icons.abc)),

                  textBox(37, double.infinity, phnNumberController, "Phone Number", const Icon(Icons.onetwothree)),

                  titlesWidget('Shipping Info'),

                  textBox(37, double.infinity, addressController, "Address", const Icon(Icons.location_on_rounded)),

                  divisionPicker(context, divisionController),

                  estimatedDelivery(),

                  itemsWidget(state),

                  Divider(color: Colors.grey.shade300,),

                  promoWidget(context, state, promoCodeController),

                  coinWidget(context, state),

                  Divider(color: Colors.grey.shade300,),

                  titlesWidget('Order Summary'),
                  orderSummaryText('Items Total', '৳ ${state.itemTotal}'),
                  orderSummaryText('Delivery Fee', '৳ 70/-'),
                  orderSummaryText('Promo Discount', '-৳ ${state.promoDiscountAmount}'),
                  Visibility(
                    visible: state.isUsingCoin ? true : false,
                    child: orderSummaryText('Coin Discount', '-৳ ${state.coinAmount / 1000}'),
                  ),

                  titlesWidget('Total : ৳ ${state.total}'),

                  const SizedBox(height: 30,),

                  buttonWidget(48, double.infinity, Colors.green, 'Place Order',
                          () => CheckOutViewModel().placeOrder(context, promoCodeController.text))
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget titlesWidget(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Widget textBox(double height, double width, TextEditingController controller, String hintText, Icon prefixIcon) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: SizedBox(
        height: height,
        width: width,
        child: TextField(
          controller: controller,
          style: const TextStyle(
            fontSize: 16,
          ),
          cursorColor: Colors.green,
          decoration: InputDecoration(
            isDense: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green),
            ),
            hintText: hintText,
            hintStyle: const TextStyle(
                fontSize: 13,
                color: Colors.grey
            ),
            prefixIcon: prefixIcon,
            //labelText: "Semester",
          ),
        ),
      ),
    );
  }

  Widget buttonWidget(double height, double width, Color bgColor, String text, VoidCallback voidCallback) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: SizedBox(
        height: height,
        width: width,
        child: ElevatedButton(
            onPressed: () {
              voidCallback();
            },
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    )
                ),
                backgroundColor: MaterialStateColor.resolveWith((states) => bgColor)
            ),
            child: Text(
              text,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
              ),
            )
        ),
      ),
    );
  }
  
  Widget divisionPicker(BuildContext context, TextEditingController divisionController) {
    final provider = BlocProvider.of<CheckoutBloc>(context);
    
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: Colors.grey,
                width: 1
            ),
            borderRadius: BorderRadius.circular(5)
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: divisionController.text != "" ? divisionController.text : "Dhaka",
              hint: const Text('Select City'),
              isDense: true,
              iconSize: 0,
              focusColor: Colors.white,
              onChanged: (String? newValue) {
                provider.add(ChangeDivisionEvent(selectedDivision: newValue!));
              },
              items: <String>[
                'Dhaka', 'Barisal', 'Chittagong', 'Khulna',
                'Mymensingh', 'Rajshahi', 'Rangpur', 'Sylhet']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              })
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget estimatedDelivery() {
    return const Padding(
      padding: EdgeInsets.only(top: 15),
      child: Text.rich(
          TextSpan(
              text: 'You will get the delivery ',
              children: <InlineSpan>[
                TextSpan(
                  text: 'within 2-3 Days ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: 'after confirmation.',
                ),
              ]
          )
      ),
    );
  }

  Widget itemsWidget(CheckOutState state) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: state.idList.length,
        itemBuilder: (context, index) {
          final String productId = state.idList[index];

          return FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('/Products')
                .doc(productId.trim())
                .get(),
            builder: (context, productSnapshot) {
              if (productSnapshot.hasData) {

                double priceAfterDiscount =
                    (productSnapshot.data!.get('price') / 100) * (100 - productSnapshot.data!.get('discount'));

                return Card(
                  elevation: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //Image
                      FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('/Products/$productId/Variations')
                            .doc(state.variantList[index])
                            .get(),
                        builder: (context, imageSnapshot) {
                          if (imageSnapshot.hasData) {
                            return GestureDetector(
                              onTap: () {
                                GoRouter.of(context).go('/product/${state.idList[index]}');
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8, top: 5, bottom: 5),
                                child: Container(
                                  width: 65,
                                  height: 65, //137 127 120 124
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
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
                          else if (imageSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return ItemUtil().loadingWidget(context, 0.4);
                          }
                          else {
                            return ItemUtil().errorWidget(context, 'Error Loading Data');
                          }
                        },
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
                                Text(
                                  productSnapshot.data!.get('title'),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                //Quantity
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        //Size
                                        Text(
                                          'Size: ${state.sizeList[index]}',
                                          style: const TextStyle(
                                              fontSize: 11,
                                              color: Colors.black54,
                                              overflow: TextOverflow.ellipsis),
                                        ),

                                        //Variant
                                        Text(
                                          'Variant: ${state.variantList[index]}',
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 11, color: Colors.black54),
                                        ),

                                        //Quantity
                                        Text(
                                          'Quantity: ${state.quantityList[index]}',
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 11, color: Colors.black54),
                                        ),
                                      ],
                                    ),

                                    //Price
                                    Padding(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: Text(
                                        '৳ ${priceAfterDiscount * state.quantityList[index]}',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 17,
                                            color: Colors.purple,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              else if (productSnapshot.connectionState == ConnectionState.waiting) {
                //return loadingWidget(context, 0.4);
                return ItemUtil().shimmerLoading(context);
              }
              else {
                return ItemUtil().errorWidget(context, 'Error Loading Data');
              }
            },
          );
        },
      ),
    );
  }

  Widget promoWidget(BuildContext context, CheckOutState state, TextEditingController promoCodeController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            textBox(
                60, MediaQuery.of(context).size.width*0.7,
                promoCodeController, 'Enter Promo Code',
                const Icon(Icons.sell_rounded)
            ),
            buttonWidget(
                48, MediaQuery.of(context).size.width*0.3 - 25, Colors.green, 'Apply',
                    () => CheckOutViewModel().promoCodeOnTapFunctions(context, promoCodeController.text)),
          ],
        ),

        Visibility(
          visible: state.isPromoCodeFound ? false : true,
          child: const Text(
            'Sorry, this promo code is not valid.',
            style: TextStyle(
              color: Colors.red
            ),
          ),
        )
      ],
    );
  }

  Widget coinWidget(BuildContext context, CheckOutState state) {
    final provider = BlocProvider.of<CheckoutBloc>(context);
    double coinDiscountAmount = state.coinAmount / 1000;

    return Row(
      children: [
        const Text(
          '🪙 Use Coins',
          style: TextStyle(
              fontWeight: FontWeight.bold
          ),
        ),
        const Expanded(child: SizedBox()),
        Text(
          '-৳ $coinDiscountAmount',
        ),
        Checkbox(
          value: state.isUsingCoin,
          onChanged: (value) {
            //means already using coins, now it's going to changed to no using. So, we have to increase the total
            if(state.isUsingCoin){
              provider.add(UpdateTotal(total: state.total + coinDiscountAmount));
            }
            //means not using coins, now it's going to changed to using. So, we have to decrease the total
            else {
              provider.add(UpdateTotal(total: state.total - coinDiscountAmount));
            }
            provider.add(UpdateIsUsingCoinEvent(isUsingCoin: !state.isUsingCoin));
          },
        )
      ],
    );
  }

  Widget orderSummaryText(String text1, String text2) {
    return Row(
      children: [
        Text(
          text1,
        ),
        const Expanded(child: SizedBox()),
        Text(
          text2,
        ),
      ],
    );
  }
}
