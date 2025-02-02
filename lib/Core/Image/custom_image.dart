// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';

// Project imports:
import 'package:stormymart_v2/Core/theme/color.dart';

class CustomImage extends StatelessWidget {
  const CustomImage(this.image, {super.key, this.width = 100, this.height = 100, this.bgColor,
    this.borderWidth = 0, this.borderColor, this.trBackground = false, this.fit = BoxFit.cover,
    this.isNetwork = true, this.radius = 50, this.borderRadius, this.isShadow = true});
  final String image;
  final double width;
  final double height;
  final double borderWidth;
  final bool isShadow;
  final Color? borderColor;
  final Color? bgColor;
  final bool trBackground;
  final bool isNetwork;
  final double radius;
  final BorderRadiusGeometry? borderRadius;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return
      Container(
          width: width, height: height,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: borderRadius ?? BorderRadius.circular(radius),
            boxShadow: [
              if(isShadow) BoxShadow(
                color: shadowColor.withValues(alpha: 0.1),
                spreadRadius: 0,
                blurRadius: 0,
                offset: const Offset(0, 0), // changes position of shadow
              ),
            ],
          ),
          child: isNetwork ?
          CachedNetworkImage(
            imageUrl: image,
            placeholder: (context, url) => const BlankImageWidget(),
            errorWidget: (context, url, error) => const BlankImageWidget(),
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: borderRadius ?? BorderRadius.circular(radius),
                image: DecorationImage(
                    image: imageProvider,
                    fit: fit
                ),
              ),
            ),
          )
              :
          Image(
            image: AssetImage(image),
            fit: fit,
          )
      );
  }
}

class BlankImageWidget extends StatefulWidget {
  const BlankImageWidget({ super.key });

  @override
  BlankImageWidgetState createState() => BlankImageWidgetState();
}

class BlankImageWidgetState extends State<BlankImageWidget> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(0),
      child: Center(child: SizedBox(
        child: Card(
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          elevation: 0.0,
        ),
      )),
    );
  }
}
