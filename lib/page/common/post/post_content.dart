import 'package:flutter/material.dart';

class PostContent extends StatelessWidget {
  PostContent({
    super.key,
    required this.width,
    required this.content,
    this.maxLine = 2,
  });

  final double width;
  final String content;
  int? maxLine;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Text(
        content,
        style: const TextStyle(
          fontSize: 14,
        ),
        maxLines: maxLine,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
