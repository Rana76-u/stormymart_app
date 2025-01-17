// Flutter imports:
import 'package:flutter/material.dart';

class MotoLine extends StatelessWidget {
  const MotoLine({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: ListView.builder(
        itemCount: motoLineItemList.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return motoLineWidget(
              motoLineItemList[index][0],
              motoLineItemList[index][1],
              motoLineItemList[index][2],
              index
          );
        },
      ),
    );
  }
}

List motoLineItemList = [
  [Icons.shopping_bag_outlined, Colors.purple, 'Authentic Products'],
  [Icons.delivery_dining_outlined, Colors.redAccent, 'Fastest Delivery'],
  [Icons.wallet_outlined, Colors.greenAccent, '100% Secure Payment'],
  [Icons.support_agent_outlined, Colors.orange, '24/7 Support']
];

Widget motoLineWidget(IconData icon, Color iconColor, String text, int index) {
  return Row(
    children: [

      const SizedBox(width: 5,),

      index != 0 ?
          SizedBox(
            height: 35,
            child: VerticalDivider(
              width: 3,
              color: Colors.grey.shade400,
            ),
          )
          :
      const SizedBox(),

      const SizedBox(width: 5,),
      Icon(
        icon,
        color: iconColor,
        size: 25,
      ),
      const SizedBox(width: 5,),
      Text(
          text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade900,
          overflow: TextOverflow.clip
        ),
      ),
    ],
  );
}
