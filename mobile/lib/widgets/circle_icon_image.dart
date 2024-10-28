import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CircleIconImage extends StatelessWidget {
  const CircleIconImage({
    Key? key,
    required this.imageUrl,
    required this.diameter,
    required this.errorImagePath,
  }) : super(key: key);

  final String imageUrl;
  final double diameter;
  final String errorImagePath;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: diameter,
      height: diameter,
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: imageUrl,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        errorWidget: (c, s, o) => Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey,
            image: DecorationImage(
              image: AssetImage(errorImagePath),
            ),
          ),
        ),
      ),
    );
  }
}
