import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ShowRewardCoinScreen extends StatefulWidget {
  final double rewardCoins;
  final double newCoinBalance;

  const ShowRewardCoinScreen({
    super.key,
    required this.rewardCoins,
    required this.newCoinBalance
  });

  @override
  State<ShowRewardCoinScreen> createState() => _ShowRewardCoinScreenState();
}

class _ShowRewardCoinScreenState extends State<ShowRewardCoinScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        /*Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomePage()), (route) => false);*/
        GoRouter.of(context).go('/');
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /*Image.asset(
                  'assets/lottie/gold-coin.gif',
                  width: double.infinity,
                ),*/

                const Text(
                  "You'll Receive The Following Reward Coins Once Your Order Gets Completed",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '+${widget.rewardCoins}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                    fontSize: 20
                  ),
                ),

                const SizedBox(height: 50,),

                Text(
                  'New Coin Balance is: ${widget.newCoinBalance}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 150,),

                GestureDetector(
                  onTap: () {

                  },
                  child: Container(
                    height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(50)
                      ),
                      child: const Icon(Icons.arrow_back_rounded)
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
