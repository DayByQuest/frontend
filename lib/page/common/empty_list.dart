import 'package:flutter/material.dart';

class ShowEmptyList extends StatelessWidget {
  final String content;

  const ShowEmptyList({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(content),
    );
  }
}
