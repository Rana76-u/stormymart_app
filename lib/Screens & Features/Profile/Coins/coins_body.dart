// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

// Project imports:
import '../../User/Data/user_hive.dart';

class CoinsBody extends StatefulWidget {
  const CoinsBody({super.key});

  @override
  State<CoinsBody> createState() => _CoinsBodyState();
}

class _CoinsBodyState extends State<CoinsBody> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Text
            const Text(
              'Remaining Coins: ',
              style: TextStyle(
                  fontSize: 30,
                  
                  fontWeight: FontWeight.bold
              ),
            ),

            //Coin Number
            FutureBuilder(
              future:  FirebaseFirestore
                  .instance
                  .collection('userData')
                  .doc(UserHive().getUserUid())
                  .get(),
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  return Row(
                    children: [
                      const Expanded(child: SizedBox()),
                      Text(
                        snapshot.data!.get('coins').toString(),
                        style: const TextStyle(
                            fontSize: 50,
                            color: Colors.amber,
                            
                            fontWeight: FontWeight.bold
                        ),
                      )
                    ],
                  );
                }else if(snapshot.connectionState == ConnectionState.waiting){
                  return const LinearProgressIndicator();
                }else{
                  return const Center(child: Text('Error Loading Data'),);
                }
              },
            ),

            const Divider(),

            //conversion rate txt
            const Text(
              'Conversion Rates of Coins: \n1 Tk for 1000 coins',
              style: TextStyle(
                  fontSize: 20,
                  
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.clip,

              ),
            ),

            const SizedBox(height: 50,),

            //instruction txt
            const Text(
              '#Buy More to Earn More',
              style: TextStyle(
                fontSize: 15,
                overflow: TextOverflow.clip,

              ),
            ),
          ],
        ),
      ),
    );
  }
}
