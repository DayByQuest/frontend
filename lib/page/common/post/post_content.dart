import 'package:flutter/material.dart';

class PostContent extends StatelessWidget {
  const PostContent({
    super.key,
    required this.width,
    required this.content,
  });

  final double width;
  final String content;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Text(
        content,
        style: const TextStyle(
          fontSize: 14,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
