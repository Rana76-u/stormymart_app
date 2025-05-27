// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:stormymart_v2/Core/Appbar/Widgets/appbar_widget.dart';
import '../../../Screens & Features/Home/Bloc/home_state.dart';

Widget coreAppBarBuildBody(BuildContext context, HomeState state) {
  return Padding(
    padding: const EdgeInsets.only(top: 30),
    child: SizedBox(
      width: double.infinity,
      child: Row(
        children: [

          AppBarWidgets().logo(context),

          const Expanded(child: SizedBox()),

          AppBarWidgets().searchIcon(context),

          const SizedBox(width: 30,),

          AppBarWidgets().cartIcon(context),

          const SizedBox(width: 30,),

          AppBarWidgets().myOrderHistory(context),

          const SizedBox(width: 20,),
        ],
      ),
    ),
  );
}
