// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stormymart_v2/Core/Appbar/Presentation/appbar_desktop_new.dart';
import 'package:stormymart_v2/Core/Utils/platform_detector.dart';

// Project imports:
import '../../../Core/Appbar/Presentation/appbar_ui_mobile.dart';
import '../../../Core/Drawer/Presentation/category_drawer.dart';
import '../../../Core/Footer/footer.dart';
import '../../../Core/theme/color.dart';
import '../../Home/Bloc/home_bloc.dart';
import '../../Home/Bloc/home_state.dart';
import '../Bloc/cart_bloc.dart';
import '../Bloc/cart_states.dart';
import 'cart_build_body.dart';

class Cart extends StatelessWidget {
  const Cart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          return BlocBuilder<HomeBloc, HomeState>(
            builder: (context, homeState) {
              return Scaffold(
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(80),
                  child: PlatformDetector().isMobile(context)? coreAppBarMobile(context, homeState) : coreAppBarDesktopNewUI(context, homeState),
                ),
                backgroundColor: appBgColor,
                drawer: coreDrawer(context),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      cartBuildBody(context, state),

                      PlatformDetector().isMobile(context) ? coreFooterMobile() : coreFooterDesktop(),
                    ],
                  ),
                ),
              );
            },
          );
        }
    );
  }
}
