import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stormymart_v2/Core/Utils/loading_screen.dart';
import 'package:stormymart_v2/Screens%20&%20Features/CheckOut/Bloc/checkout_bloc.dart';
import 'package:stormymart_v2/Screens%20&%20Features/CheckOut/Bloc/checkout_state.dart';
import 'package:stormymart_v2/Core/Appbar/Presentation/appbar_ui_mobile.dart';
import 'package:stormymart_v2/Screens%20&%20Features/CheckOut/Presentation/checkout_build_body.dart';
import '../../Home/Bloc/home_bloc.dart';
import '../../Home/Bloc/home_state.dart';
import '../../../Core/Footer/footer.dart';

class CheckOut extends StatelessWidget {
  const CheckOut({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: BlocBuilder<CheckoutBloc, CheckOutState>(
          builder: (context, state) {
            return Scaffold(
              appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(65),
                  child: BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, homeState) {
                      return coreAppBar(context, homeState);
                    },
                  )
              ),
              body: state.isLoading ?
              showLoadingScreen("Please Wait, Your order is being placed") :
              SingleChildScrollView(
                child: Column(
                  children: [
                    checkoutBuildBody(context),

                    coreFooter(),
                  ],
                ),
              )
            );
          }),
    );
  }
}