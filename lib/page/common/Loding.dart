import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "loading",
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}
