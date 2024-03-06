import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:stormymart_v2/Screens/Home/show_all_hotdeals.dart';


class HotDealsTitle extends StatelessWidget {
  const HotDealsTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
            'Hot Deals',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                fontFamily: 'Urbanist',
                color: Color(0xFF212121)
            )
        ),

        GestureDetector(
          onTap: () {
            Get.to(
              const ShowAllHotDeals(),
              transition: Transition.fade,
            );
          },
          child: const Text(
            'See All',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                fontFamily: 'Urbanist'
            ),
          ),
        ),
      ],
    );
  }
}
