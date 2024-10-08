import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../utility/auth_service.dart';
import '../../Search/searchbar_widget.dart';

Widget homeAppbar(BuildContext context){
  return SliverAppBar(
    toolbarHeight: 75,
    backgroundColor: Colors.black,
    pinned: true,
    expandedHeight: 125, // The height when expanded
    flexibleSpace: FlexibleSpaceBar(
      collapseMode: CollapseMode.parallax, // Add parallax effect
      stretchModes: const [
        StretchMode.zoomBackground,  // Zoom the background when overscrolled
        StretchMode.fadeTitle,       // Fade the title in and out
      ],
      background: Container(
        color: Colors.black,
        padding: const EdgeInsets.only(top: 85),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {

              },
              child: const Icon(Icons.menu, color: Colors.white, size: 20,),
            ),
            const SizedBox(width: 15,),
            const SizedBox(
              height: 20,
              child: VerticalDivider(color: Colors.grey,),
            ),
            ListView.builder(
              itemCount: homeAppBarItems.length,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return appBarCategories(homeAppBarItems[index]);
              },
            )
          ],
        ),
      ),
    ),
    title: Row(
      children: [
        const Expanded(child: SizedBox()),
        //StormyMart
        Image.asset(
          'assets/images/logo/wide-logo.png',
          height: 85,
          width: 85,
        ),

        const SizedBox(width: 25,),
        //Search Bar
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: () {
              GoRouter.of(context).go('/search');
            },
            child: searchBar(context),
          ),
        ),

        topLeftItem(Icons.person_outline, 'Welcome', 'Login / Sign up', context),

        topLeftItem(Icons.shopping_cart_outlined, '0', 'Cart', context),

        const Expanded(child: SizedBox()),

      ],
    ),
    //flexibleSpace: HomePageHeader(),
  );
}

List homeAppBarItems = ['HotDeals', 'Clothing', 'Accessories', 'Home Appliances', 'Kids', 'Automotive', 'Electronics', 'Gadgets', 'Gift'];

Widget topLeftItem(IconData icon, String text1, String text2, BuildContext context) {
  return GestureDetector(
    onTap: () {
      if(text2 == 'Login / Sign up') {
        AuthService().signInWithGoogle().then((_) {
          GoRouter.of(context).go('/');
        }).catchError((error) {});
      }
    },
    child: Padding(
      padding: const EdgeInsets.only(left: 75),
      child: Row(
        children: [
          FirebaseAuth.instance.currentUser != null && text2 == 'Login / Sign up' ?
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.network(
              FirebaseAuth.instance.currentUser!.photoURL!,
              height: 25,
              width: 25,
            ),
          ) : Icon(icon, color: Colors.white,),
          const SizedBox(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              text2 != 'Cart' ?
              Text(
                text1,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white
                ),
              ) :
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 2, left: 5, right: 5, bottom: 2),
                  child: Text(
                    text1,
                    style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),

              Text(
                FirebaseAuth.instance.currentUser != null && text2 == 'Login / Sign up' ? FirebaseAuth.instance.currentUser!.displayName ?? '' : text2,
                style: const TextStyle(
                  fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}

Widget appBarCategories(String text) {
  ///todo: on hover transparent white container bg
  return Padding(
    padding: EdgeInsets.only(left: text == 'HotDeals' ? 15 : 40),
    child: Text(
      text,
      style: TextStyle(
        color: text == 'HotDeals' ? Colors.red : Colors.white,
        //fontWeight: text != 'HotDeals' ? FontWeight.w400 : FontWeight.bold,
        fontSize: 13
      ),
    ),
  );
}
