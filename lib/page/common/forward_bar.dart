import 'package:flutter/material.dart';

class ForwardBar extends StatelessWidget {
  final String description;
  final Function moveTarget;

  const ForwardBar({
    super.key,
    required this.description,
    required this.moveTarget,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        moveTarget();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            description,
            style: const TextStyle(fontSize: 16),
          ),
          const Icon(Icons.arrow_forward_ios)
        ],
      ),
    );
  }
}
