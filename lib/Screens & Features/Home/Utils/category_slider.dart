import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stormymart_v2/Core/Utils/global_variables.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Home/Data/load_category_services.dart';

class CategorySlider extends StatelessWidget {
  const CategorySlider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: SizedBox(
        height: 44.5,
        width: double.infinity,
        child: FutureBuilder(
          future: loadCategory(),
          builder: (context, snapshot) {
            if(snapshot.hasData){

              return ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {

                  String categoryName = categories.keys.elementAt(index);

                  return cards(categoryName, context);
                },
              );
            }
            else if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(
                child: LinearProgressIndicator(),
              );
            }
            else{
              return const Center(
                child: Text(''),
              );
            }
          },
        ),
      ),
    );
  }

  Widget cards(String categoryName, BuildContext context) {
    return GestureDetector(
      onTap: (){
        GoRouter.of(context).go('/search/item/$categoryName');
      },
      child: Container(
        constraints: const BoxConstraints(
          minWidth: 115,
        ),
        //width: 115,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                categoryName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

