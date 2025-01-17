// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:stormymart_v2/Screens & Features/Profile/Coins/coins_body.dart';
import 'package:stormymart_v2/Screens & Features/Profile/Coins/coins_top.dart';

class Coins extends StatefulWidget {
  const Coins({super.key});

  @override
  State<Coins> createState() => _CoinsState();
}

class _CoinsState extends State<Coins> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CoinsTop(),
            SizedBox(height: 30,),
            CoinsBody(),
          ],
        ),
      ),
    );
  }
}
