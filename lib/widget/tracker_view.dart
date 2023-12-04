import 'package:flutter/material.dart';

class TrackerView extends StatelessWidget {
  final List<int> tracker;
  final int postCount;

  const TrackerView({
    super.key,
    required this.tracker,
    required this.postCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'total: $postCount 퀘스트 완료',
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
          color: Color(0xFFD3D3D3).withOpacity(0.2),
          child: GridView.count(
            crossAxisCount: 12,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(60, (index) {
              return Container(
                  color: Color(0xFF82589F)
                      .withOpacity((tracker[index].toDouble() * 0.06) + 0.1));
            }),
          ),
        ),
      ],
    );
  }
}

              // Color.fromRGBO(
              //     35, 236, 116, (tracker[index].toDouble() * 0.06) + 0.1),
