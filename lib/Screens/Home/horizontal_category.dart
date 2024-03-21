import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


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

                color: Color(0xFF212121)
            )
        ),

        GestureDetector(
          onTap: () {
            GoRouter.of(context).go('/hotdeals');
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
