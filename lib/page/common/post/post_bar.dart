import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

class PostBar extends StatelessWidget {
  const PostBar({
    super.key,
    required this.width,
    required this.imageLength,
    required this.curImageIndex,
    required this.isLike,
    required this.changeLikePost,
  });

  final double width;
  final int imageLength;
  final int curImageIndex;
  final bool isLike;
  final Function changeLikePost;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 48,
          width: width,
          child: DotsIndicator(
            dotsCount: imageLength,
            position: curImageIndex,
          ),
        ),
        SizedBox(
          height: 48,
          child: IconButton(
            icon: Icon(
              isLike ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: () {
              changeLikePost();
            },
          ),
        )
      ],
    );
  }
}
