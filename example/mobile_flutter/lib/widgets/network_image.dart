import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart' as package;

class CachedNetworkImage extends StatelessWidget{
  final String url;
  final double height;
  final double width;
  final BoxFit fit;

  CachedNetworkImage({
    @required this.url,
    this.height: 100.0,
    this.width: 100.0,
    this.fit: BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    final nothumb = Image.asset(
      'assets/nothumb.png',
      height: height,
      width: width,
      fit: fit,
      );

    if (url == null){
      return nothumb;
    } else if (!url.startsWith('http')) {
      return Image.asset(
        url,
        height: height,
        width: width,
        fit: fit,
      );
    } else {
      return package.CachedNetworkImage(
        imageUrl: url,
        height: height,
        width: width,
        fit: fit,
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => nothumb,
      );
    }
  }
}
