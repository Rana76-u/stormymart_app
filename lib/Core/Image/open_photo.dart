// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'image_viewer_gallery.dart';

class OpenPhoto {

  void openPhotoGallery(BuildContext context, final int index, List<dynamic> galleryItemList) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryPhotoViewWrapper(
          galleryItems: galleryItemList,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: index,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }

}
