import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LikeButton extends StatelessWidget {
  final Function onTap;
  final int likes;
  final bool hasLiked;

  const LikeButton({
    Key key,
    this.onTap,
    this.likes = 0,
    this.hasLiked = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: 10.0,
          ),
          child: GestureDetector(
            onTap: onTap,
            child: Icon(
              hasLiked ? Icons.favorite : Icons.favorite_outline,
              size: 60,
              color: !hasLiked ? Colors.white : Color(0xFFC2185B),
            ),
          ),
        ),
        Text(
          NumberFormat.compact().format(likes),
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
