// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import '../../../Screens & Features/Cart/Bloc/cart_bloc.dart';
import '../../../Screens & Features/Cart/Bloc/cart_states.dart';
import '../../../Screens & Features/Home/Bloc/home_state.dart';
import '../../../Screens & Features/User/Data/user_hive.dart';

Widget coreAppBar(BuildContext context, HomeState state) {
  return AppBar(
    leading: Builder(
      builder: (context) => IconButton(
        icon: const Icon(Icons.menu, color: Colors.white,),
        onPressed: () => Scaffold.of(context).openDrawer()
      ),
    ),
    backgroundColor: Colors.black,
    title: mainAppBarPart(context, state),
    elevation: 10,
  );
}

Widget mainAppBarPart(BuildContext context, HomeState state) {
  return SizedBox(
    width: double.infinity,
    child: Row(
      children: [

        //StormyMart
        logo(context),

        const Expanded(child: SizedBox()),

        searchIcon(context),

        const SizedBox(width: 30,),

        cartIcon(context),

        const SizedBox(width: 30,),

        userIcon(context),

        const SizedBox(width: 20,),
      ],
    ),
  );
}

Widget logo(BuildContext context) {
  return GestureDetector(
    onTap: () {
      GoRouter.of(context).push('/');
    },
    child: Image.asset(
      'assets/images/logo/wide-logo.png',
      height: 85,
      width: 85,
    ),
  );
}
Widget searchIcon(BuildContext context){
  return GestureDetector(
    onTap: () {
      GoRouter.of(context).push('/search');
    },
    child: const Icon(Icons.search, color: Colors.white,),
  );
}
Widget cartIcon(BuildContext context){
  return GestureDetector(
    onTap: () {
      GoRouter.of(context).push('/cart');
    },
    child: Stack(
      children: [
        const Positioned(
          child: Icon(Icons.shopping_cart_outlined, color: Colors.white,),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          child: BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 2, left: 5, right: 5, bottom: 2),
                  child: Text(
                    state.idList.length.toString(),
                    style: const TextStyle(
                        fontSize: 9,
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              );
            },
          ),
        )
      ],
    ),
  );
}
Widget userIcon(BuildContext context){
  return GestureDetector(
    onTap: () {
      GoRouter.of(context).push('/profile');
    },
    child: FirebaseAuth.instance.currentUser != null ?
    ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Image.network(
        UserHive().getUserPhotoURL(),
        height: 25,
        width: 25,
      ),
    ) :
    const Icon(Icons.person_outline, color: Colors.white,),
  );
}
