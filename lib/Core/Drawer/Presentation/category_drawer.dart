// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:transparent_image/transparent_image.dart';

// Project imports:
import 'package:stormymart_v2/Core/Utils/core_progress_bars.dart';
import 'package:stormymart_v2/Core/Utils/errors_n_empty_messages.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Home/Data/load_category_services.dart';
import '../../../Screens & Features/Profile/profile.dart';
import '../../../Screens & Features/User/Data/user_hive.dart';
import '../../Utils/global_variables.dart';

Widget coreDrawer(BuildContext context){
  return Drawer(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(0),
          bottomRight: Radius.circular(0)),
    ),
    child: ListView(
      children: [
        drawerHeader(context),

        drawerItems(context),
      ],
    ),
  );
}

Widget drawerHeader(BuildContext context) {
  return DrawerHeader(
    decoration: const BoxDecoration(
      //color: Color(0xFF0d1b2a)
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if(FirebaseAuth.instance.currentUser != null)...[
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Profile(),)
              );
            },
            child: Row(
              children: [
                SizedBox(
                  height: 45,
                  width: 45,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: FadeInImage.memoryNetwork(
                      image: UserHive().getUserPhotoURL() ??
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSgBhcplevwUKGRs1P-Ps8Mwf2wOwnW_R_JIA&usqp=CAU',
                      placeholder: kTransparentImage,
                    ),
                  ),
                ),
                const SizedBox(width: 14,),
                SizedBox(
                  width: 170,
                  child: Text(
                    UserHive().getUserName(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.black,
                        overflow: TextOverflow.ellipsis
                    ),
                  ),
                ),
              ],
            ),
          )
        ]
        else...[
          SizedBox(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: WidgetStateColor.resolveWith((states) => Colors.black),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                ),
              ),
              onPressed: () {
                //open login page
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Profile(),
                ));
              },
              child: const Text(
                'Sign in using Google',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13
                ),
              ),
            ),
          ),
        ],
        //const Expanded(child: SizedBox()),
        const Padding(
          padding: EdgeInsets.only(left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Browse',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Colors.black
                ),
              ),
              Text(
                'StormyMart',
                style: TextStyle(
                    fontSize: 21,

                    fontWeight: FontWeight.w700,
                    color: Colors.black
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}

Widget drawerItems(BuildContext context) {
  return FutureBuilder(
    future: loadCategory(),

    builder: (context, snapshot) {

      if(snapshot.hasData){

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            String categoryName = categories.keys.elementAt(index);
            List<dynamic> subCategoryNames = categories.values.elementAt(index);
            return ExpansionTile(
              iconColor: Colors.amber,
              textColor: Colors.amber,
              title: Text(
                  categoryName,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                  )
              ),
              childrenPadding: const EdgeInsets.only(left: 60),
              children: List.generate(
                subCategoryNames.length,
                    (index) {
                  return ListTile(
                    title: Text(subCategoryNames[index]),
                    onTap: () {
                      keyword = subCategoryNames[index];
                      GoRouter.of(context).push('/search/item/$keyword');
                    },
                  );
                },
              ),
            );
          },
        );
      }
      else if(snapshot.connectionState == ConnectionState.waiting){
        return centeredLinearProgress(context);
      }
      else{
        return ErrorsAndEmptyMessages.emptyMessage();
      }
    },
  );
}
