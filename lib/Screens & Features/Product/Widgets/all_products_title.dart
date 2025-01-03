import 'package:flutter/material.dart';

class PopularItemsTitle extends StatelessWidget {
  const PopularItemsTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 30, bottom: 20),
      child: Center(
        child: Text(
          'Popular Items',
          style: TextStyle(
              fontSize: 40,
              overflow: TextOverflow.clip
          ),
        ),
      ),
    );
  }
}
