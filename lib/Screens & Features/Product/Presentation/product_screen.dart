// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:stormymart_v2/Core/theme/color.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Home/Bloc/home_bloc.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Home/Bloc/home_state.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Product/Bloc/product_states.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Product/Widgets/View%20Product/view_product_widgets.dart';
import '../../../Core/Appbar/Presentation/appbar_desktop_new.dart';
import '../../../Core/Appbar/Presentation/appbar_ui_mobile.dart';
import '../../../Core/Footer/footer.dart';
import '../../../Core/Utils/platform_detector.dart';
import '../Bloc/product_bloc.dart';
import '../Bloc/product_events.dart';
import 'product_build_body.dart';

class ProductScreen extends StatelessWidget {
  final String productId;

  const ProductScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final productBloc = BlocProvider.of<ProductBloc>(context);

    // Dispatch the initialization events
    WidgetsBinding.instance.addPostFrameCallback((_) {
      productBloc.add(InitializeProductPage(productId: productId));
      productBloc.add(UpdateFavCats(productId: productId));
    });

    //BlockBuilder for ProductBloc
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        return Scaffold(
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(80),
              child: BlocBuilder<HomeBloc, HomeState>(
                builder: (context, homeState) {
                  return PlatformDetector().isMobile(context) ? coreAppBarMobile(context, homeState) : coreAppBarDesktopNewUI(context, homeState);
                },
              )
          ),
          backgroundColor: appBgColor,
          floatingActionButton: ViewProductWidgets().floatingButtonWidget(state.productID, context),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    PlatformDetector().isMobile(context) ?
                    productBuildBodyMobile(context, state, state.productID) :
                    productBuildBodyDesktop(context, state, state.productID),

                    PlatformDetector().isMobile(context) ? coreFooterMobile() : coreFooterDesktop(),
                  ],
                ),
              ),

              ViewProductWidgets().blurEffect()
            ],
          ),
        );
      },
    );
  }
}
