// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:stormymart_v2/Screens & Features/Profile/profile_accountinfo.dart';
import '../User/Data/user_hive.dart';

class ProfileTop extends StatefulWidget {
  const ProfileTop({super.key});

  @override
  State<ProfileTop> createState() => _ProfileTopState();
}

class _ProfileTopState extends State<ProfileTop> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //BG Image
        Container(
          color: Colors.blueGrey,
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.29,
          /*child: Image.asset(
            'assets/images/orange_abstract_bg.jpg',
            fit: BoxFit.cover,
          ),*/
        ),
        //Info's
        Positioned(
          height: 50,
          width: MediaQuery.of(context).size.width,
          top: MediaQuery.of(context).size.height*0.1,
          left: 20,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Profile Photo
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  UserHive().getUserPhotoURL().toString(),
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 20,),
              //Texts
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(child: SizedBox()),
                  Text(
                    UserHive().getUserName().toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        
                        fontSize: 18,
                        overflow: TextOverflow.ellipsis
                    ),
                  ),
                  Text(
                    UserHive().getUserEmail().toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),
              const SizedBox(width: 50,),
              //Settings Icons
              GestureDetector(
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const AccountInfo(),)
                  );
                },
                child: const Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
        //Three items
        FutureBuilder(
          future:  FirebaseFirestore
              .instance
              .collection('userData')
              .doc(UserHive().getUserUid())
              .get(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              List wishlist = snapshot.data!.get('wishlist');
              //List coupons = snapshot.data!.get('coupons');
              return Positioned(
                top: MediaQuery.of(context).size.height*0.21,
                left: MediaQuery.of(context).size.height*0.07,
                right: MediaQuery.of(context).size.height*0.07,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //wishlist
                    GestureDetector(
                      onTap: () {
                        GoRouter.of(context).go('/wishlists');
                      },
                      child: Column(
                        children: [
                          Text(
                            wishlist.length.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Text(
                            'Wishlist',
                            style: TextStyle(
                                color: Colors.white,
                                overflow: TextOverflow.ellipsis,
                                fontFamily: 'Urbanist'
                            ),
                          )
                        ],
                      ),
                    ),

                    //Points
                    GestureDetector(
                      onTap: () {
                        GoRouter.of(context).go('/coin');
                      },
                      child: Column(
                        children: [
                          Text(
                            snapshot.data!.get('coins').toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Text(
                            'Coins',
                            style: TextStyle(
                                color: Colors.white,
                                overflow: TextOverflow.ellipsis,
                                fontFamily: 'Urbanist'
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }else if(snapshot.connectionState == ConnectionState.waiting){
              return const LinearProgressIndicator();
            }else{
              return const Center(child: Text('Error Loading Data'),);
            }
          },
        ),
      ],
    );
  }
}
