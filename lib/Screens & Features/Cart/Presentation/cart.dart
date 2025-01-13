import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Core/Appbar/Presentation/appbar_ui_mobile.dart';
import '../../../Core/Drawer/Presentation/category_drawer.dart';
import '../../../Core/theme/color.dart';
import '../Bloc/cart_bloc.dart';
import '../Bloc/cart_states.dart';
import '../../Home/Bloc/home_bloc.dart';
import '../../Home/Bloc/home_state.dart';
import '../../../Core/Footer/footer.dart';
import 'cart_build_body.dart';

class Cart extends StatelessWidget {
  const Cart({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            return BlocBuilder<HomeBloc, HomeState>(
              builder: (context, homeState) {
                return Scaffold(
                  appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(65),
                    child: coreAppBar(context, homeState),
                  ),
                  backgroundColor: appBgColor,
                  drawer: coreDrawer(context),
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        cartBuildBody(context, state),

                        coreFooter(),
                      ],
                    ),
                  ),
                );
              },
            );
          }
      ),
    );
  }
}
