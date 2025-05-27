// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stormymart_v2/Core/Utils/platform_detector.dart';

// Project imports:
import '../../../Screens & Features/Cart/Bloc/cart_bloc.dart';
import '../../../Screens & Features/Cart/Bloc/cart_states.dart';
import '../../../Screens & Features/User/Data/user_hive.dart';

class AppBarWidgets {

  Widget logo(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GoRouter.of(context).go('/');
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
        GoRouter.of(context).go('/search');
      },
      child: const Icon(Icons.search, color: Colors.white,),
    );
  }
  Widget cartIcon(BuildContext context){
    return GestureDetector(
      onTap: () {
        GoRouter.of(context).go('/cart');
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
        GoRouter.of(context).go('/profile');
        //Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Profile()));
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
      const Icon(Icons.person, color: Colors.white,),
    );
  }

  Widget myOrderHistory(BuildContext context) {
    return TextButton(
      onPressed: () {
        GoRouter.of(context).go('/orders');
      },
      child: Text(
        PlatformDetector().isMobile(context) ?  'My Orders' : '🛒 My Orders',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontSize: PlatformDetector().isMobile(context) ? 10 : 22, // Adjust font size
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
          shadows: [
            Shadow(
              offset: const Offset(1.5, 1.5),
              blurRadius: 3.0,
              color: Colors.black.withValues(alpha: 0.3),
            ),
          ],
        ),
      ),
    );
  }

}
