// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../User/Data/user_hive.dart';

class WishListTop extends StatelessWidget {
  const WishListTop({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height*0.055,), //0.05, 0.075
          //Top BAR
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              const Text(
                'WishList',
                style: TextStyle(
                    fontSize: 22,
                    
                    fontWeight: FontWeight.bold
                ),
              ),

              //Profile Photo
              GestureDetector(
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 2.5, color: Colors.grey.shade400),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(UserHive().getUserPhotoURL().toString()),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
