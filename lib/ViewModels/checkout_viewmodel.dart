import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../Components/notification_sender.dart';

class CheckOutViewModel {

  Future<String> generateRandomID()  async {
    Random random = Random();
    String randomID  = '';
    const String chars = "0123456789abcdefghijklmnopqrstuvwxyz";

    for (int i = 0; i < 20; i++) {
      randomID += chars[random.nextInt(chars.length)];
    }

    return randomID;
  }

  /*Future<void> fetchCartItemsAndPlaceOrder(
      String usedPromoCode, double usedCoins, double total,
      String selectedAddress, String selectedDivision) async {

    String randomID = await generateRandomID();

    final cartSnapshot = await FirebaseFirestore.instance
        .collection('userData')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Cart')
        .get();

    //Enable Order Collection
    await FirebaseFirestore
        .instance
        .collection('Orders')
        .doc(FirebaseAuth.instance.currentUser!.uid).set({
      'enable': true
    });

    //Order necessary details
    await FirebaseFirestore
        .instance
        .collection('Orders')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Pending Orders').doc(randomID).set({
      'usedPromoCode': usedPromoCode,
      'usedCoin': usedCoins,
      'total' : total,
      'deliveryLocation': '$selectedAddress, $selectedDivision',
      'time' : FieldValue.serverTimestamp(),
    });

    //Each Order Details
    for (var doc in cartSnapshot.docs) {
      //For every Cart item
      String randomOrderListDocID = await generateRandomID();
      // add them into Order list
      await FirebaseFirestore
          .instance
          .collection('Orders')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('Pending Orders').doc(randomID).collection('orderLists').doc(randomOrderListDocID).set({
        'productId' : doc['id'],
        'quantity' : doc['quantity'],
        'selectedSize' : doc['selectedSize'],
        'variant' : doc['variant'],
      });

      //For MultiVendor
      //At shop location save the reference
      // Reference to the orderLists document
      *//*DocumentReference orderListsReference = FirebaseFirestore.instance
          .collection('Orders')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('Pending Orders')
          .doc(randomID)
          .collection('orderLists')
          .doc(randomOrderListDocID);

      // Update the '/Admin Panel' document with the reference value
      await FirebaseFirestore.instance
          .collection('/Admin Panel')
          .doc(doc['Shop ID'])
          .set({
        'Pending Orders': FieldValue.arrayUnion([orderListsReference])
      }, SetOptions(merge: true));*//*

      //Then Delete added item from cart
      await FirebaseFirestore.instance
          .collection('userData')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('Cart')
          .doc(doc.id).delete();
    }

    double previousCoins = 0.0;
    double remainingCoins = 0.0;

    if(usedCoins != 0){
      //Decrease Coin Value
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('userData')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      previousCoins = snapshot.get('coins').toDouble();

      setState(() {
        remainingCoins = previousCoins - usedCoins;

        rewardCoin =  (total / 100) * 1000;

        //newTotalCoins = remainingCoins + rewardCoin;
      });

      //update new Coin Value
      await FirebaseFirestore.instance
          .collection('userData')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'coins' : remainingCoins
      });
    }

    await sendNotification();

    setState(() {
      isLoading = false;

      if(isLoading == false){
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Congratulations 🎉, Your Order has been Placed.')
            )
        );

        if(widget.usedCoins != 0){
          Get.to(
              ShowRewardCoinScreen(
                rewardCoins: rewardCoin,
                newCoinBalance: remainingCoins,//newTotalCoins
              ),
              transition: Transition.fade
          );
        }
        else{
          GoRouter.of(context).go('/');
        }
      }
    });
  }*/

  Future<void> sendNotification() async {

    //Get all the admins Id's
    CollectionReference reference = FirebaseFirestore.instance.collection('/Admin Panel');

    QuerySnapshot querySnapshot = await reference.get();

    for (var doc in querySnapshot.docs) {
      if(doc.id != 'Sell Data'){

        final tokenSnapshot = await FirebaseFirestore.instance.collection('userTokens')
            .doc(doc.id).get();

        String token = tokenSnapshot.get('token');

        await SendNotification.toSpecific(
            "Order Update",
            'New Order Placed',
            token,
            'BottomBar()'
        );
      }
    }
  }

}