// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:photo_view/photo_view.dart';

// ignore: must_be_immutable
class ImageViewerScreen extends StatefulWidget {
  String imageUrl;
  ImageViewerScreen({super.key, required this.imageUrl});

  @override
  State<ImageViewerScreen> createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<ImageViewerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: widget.imageUrl,
            child: PhotoView(
              imageProvider: NetworkImage(
                  widget.imageUrl,
              ),
              maxScale: 4.0,
              loadingBuilder: (context, event) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ),
        onTap: (){
          Navigator.pop(context);
        },
      ),
    );
  }
}
