import 'package:flutter/material.dart';

Widget searchBar(BuildContext context) {
  return Container(
    height: 45,
    padding: const EdgeInsets.only(left: 20, right: 5, ),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
    ),
    child: TextField(
      //focusNode: _focusNode,
      style: const TextStyle(
        fontSize: 13
      ),
      decoration: InputDecoration(
        hintText: "Search",
        hintStyle: const TextStyle(
            fontSize: 13,
            color: Colors.grey,
        ),
        suffixIcon: GestureDetector(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.search_rounded,
                color: Colors.white,
                size: 20,
              ),
            )
        ),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
      ),

    ),
  );
}