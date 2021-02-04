import 'package:flutter/material.dart';

class AvatarBtn extends StatelessWidget {
  final String photoURL;
  final String tag;
  final Function onTap;

  const AvatarBtn({
    Key key,
    this.photoURL,
    this.tag,
    this.onTap,
  }) : super(key: key);

  Widget avatar(String photoURL) {
    return CircleAvatar(
      radius: 28.0,
      backgroundImage: NetworkImage(photoURL),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 20.0,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: tag != null
            ? Hero(
                tag: tag,
                child: avatar(photoURL),
              )
            : avatar(photoURL),
      ),
    );
  }
}
