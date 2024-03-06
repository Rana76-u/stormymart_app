import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HorizontalSlider extends StatelessWidget {
  const HorizontalSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      width: double.infinity,
      child: FutureBuilder(
        future: FirebaseFirestore.instance.collection('/Category').doc('/Drawer').get(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            int length = snapshot.data!.data()!.keys.length;
            return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: length,
              itemBuilder: (context, index) {
                String title = snapshot.data!.data()!.keys.elementAt(index);

                return cards(title, context);
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
              child: Text('Nothings Here'),
            );
          }
        },
      ),
    );
  }

  Widget cards(String title, BuildContext context) {
    return GestureDetector(
      onTap: (){
        GoRouter.of(context).go('/search/searchTerm/$title');
      },
      child: SizedBox(
        width: 160,//MediaQuery.of(context).size.width*0.4,
        child: Card(
          //margin: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

