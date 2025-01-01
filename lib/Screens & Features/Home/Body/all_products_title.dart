import 'package:flutter/material.dart';

class AllProductsTitle extends StatelessWidget {
  const AllProductsTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'All Products',
        style: TextStyle(
            fontSize: 40,
            overflow: TextOverflow.clip
        ),
      ),
    );
  }
}
