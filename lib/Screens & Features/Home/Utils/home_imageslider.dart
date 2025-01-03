import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

import '../../../Components/custom_image.dart';

class ImageSlider extends StatelessWidget {
  const ImageSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('Banners').get(),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          List<String> images = [];
          for(int i =0; i<snapshot.data!.docs.length; i++){
            images.add(snapshot.data?.docs[i]['image']);
          }
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width <= 600 ? 181
                :
            MediaQuery.of(context).size.height*0.4,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: images.isNotEmpty ? ImageSlideshow(
                height: 200, //MediaQuery.of(context).size.height * 0.45,
                initialPage: 0,
                indicatorColor: Colors.amber,
                indicatorBackgroundColor: Colors.grey,
                onPageChanged: (value) {},
                autoPlayInterval: 8000,
                isLoop: true,
                children: List.generate(images.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: CustomImage(
                      images[index],
                      radius: 10,
                      //fit: BoxFit.cover,
                    ),
                  );
                })
            )
                :
            Image.network(
              'https://cdn.dribbble.com/users/256646/screenshots/17751098/media/768417cc4f382d6171053ad620bc3c3b.png',
              fit: BoxFit.cover,
            ),
          );
        }
        else if(snapshot.connectionState == ConnectionState.waiting){
          return const LinearProgressIndicator();
        }
        else{
          return const Center(
            child: Text(
              'Nothing Found',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold
              ),
            ),
          );
        }
      },
    );
  }
}
