import 'package:flutter/material.dart';

Widget topLeftItem(IconData icon, String text1, String text2) {
  return Padding(
    padding: const EdgeInsets.only(left: 75),
    child: Row(
      children: [
        Icon(icon, color: Colors.white,),
        const SizedBox(width: 10,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            text2 != 'Cart' ?
            Text(
              text1,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white
              ),
            ) :
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 2, left: 5, right: 5, bottom: 2),
                child: Text(
                  text1,
                  style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),

            Text(
              text2,
              style: const TextStyle(
                fontSize: 11,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
              ),
            ),
          ],
        )
      ],
    ),
  );
}

Widget appBarCategories(String text) {
  ///todo: on hover trasparent white container bg
  return Padding(
    padding: EdgeInsets.only(left: text == 'All Categories' ? 15 : 40),
    child: Text(
      text,
      style: TextStyle(
        color: text == 'HotDeals' ? Colors.red : Colors.white,
        fontWeight: text != 'HotDeals' ? FontWeight.w400 : FontWeight.bold,
        fontSize: 17
      ),
    ),
  );
}
