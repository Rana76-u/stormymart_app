import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stormymart_v2/Screens%20&%20Features/CheckOut/Widgets/checkout_widgets.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Payment/Widgets/payment_card.dart';
import '../../../Core/Appbar/Presentation/appbar_ui_mobile.dart';
import '../../Home/Bloc/home_bloc.dart';
import '../../Home/Bloc/home_state.dart';
import '../Data/payment_services.dart';

class PaymentPage extends StatelessWidget {
  final double transAmount;
  final String transId;
  const PaymentPage({super.key, required this.transAmount, required this.transId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(65),
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, homeState) {
              return coreAppBar(context, homeState);
            },
          )
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 50),
                child: Card(
                  elevation: 0,
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Your order has been received. To complete the confirmation, please proceed to payment',
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ),

              paymentCard(),

              CheckoutWidgets().buttonWidget(
                  48, double.infinity, Colors.green, 'Pay Now',
                      () {
                        PaymentServices().startSSLCommerzTransaction(context, transAmount, transId);
              }),
            ],
          ),
        ),
      ),
    );
  }
}