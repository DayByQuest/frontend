import 'package:flutter/material.dart';

class ShowEmptyList extends StatelessWidget {
  final String content;

  const ShowEmptyList({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 32;

    return SizedBox(
      width: width,
      height: width,
      child: Center(
        child: Text(content),
      ),
    );
  }
}
