// Flutter imports:
import 'package:flutter/material.dart';

class DeliveryContainer extends StatelessWidget {
  const DeliveryContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          color: Colors.blue.withValues(alpha: 0.2),
        ),
        height: 100 ,
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Icon(
                Icons.local_shipping_rounded,
                color: Colors.redAccent,
                size: 70,
              ),
            ),

            const SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(child: SizedBox()),
                const Text(
                  'Cash on Delivery',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 5,),
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.55,
                  child: const Text(
                    'Inside Dhaka 1-3 Days, \nOutside Dhaka 2-4 Days',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      overflow: TextOverflow.clip
                    ),
                  ),
                ),
                const Expanded(child: SizedBox()),
              ],
            )
          ],
        ),
      );
  }
}
