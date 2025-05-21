// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:stormymart_v2/Core/Appbar/Presentation/appbar_mobile_buildbody.dart';
import '../../../Screens & Features/Home/Bloc/home_state.dart';

Widget coreAppBarMobile(BuildContext context, HomeState state) {
  return AppBar(
    leading: Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: Colors.white,),
          onPressed: () => Scaffold.of(context).openDrawer()
        ),
      ),
    ),
    backgroundColor: Colors.black,
    title: coreAppBarBuildBody(context, state),
    elevation: 10,
  );
}




