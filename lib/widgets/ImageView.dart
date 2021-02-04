import 'package:flutter/material.dart';

class ImageView extends StatelessWidget {
  final Function(TapDownDetails) onTapDown;
  final String tag;
  final String imageURL;

  const ImageView({
    Key key,
    this.tag,
    this.onTapDown,
    @required this.imageURL,
  }) : super(key: key);

  Widget image(String imageURL, BuildContext context) {
    return Image(
      fit: BoxFit.cover,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      image: NetworkImage(imageURL),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: onTapDown,
      child: tag != null
          ? Hero(
              tag: tag,
              child: image(imageURL, context),
            )
          : image(imageURL, context),
    );
  }
}
