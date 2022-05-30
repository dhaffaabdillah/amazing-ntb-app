import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:travel_hour/constants/constants.dart';

class CustomCacheImage extends StatelessWidget {
  final String? imageUrl;
  const CustomCacheImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl!= null ? imageUrl! : Constants.defaultPath,
      fit: BoxFit.cover,
      height: MediaQuery.of(context).size.height,
      placeholder: (context, url) => Container(color: Colors.grey[300]),
      errorWidget: (context, url, error) => Container(
        color: Colors.grey[300],
        child: Icon(Icons.error),
      ),
    );
  }
}