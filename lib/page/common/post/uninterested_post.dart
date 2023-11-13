import 'package:flutter/material.dart';
import 'package:flutter_application_1/page/common/Buttons.dart';

class UninterestedPost extends StatelessWidget {
  const UninterestedPost({
    super.key,
    required this.cancleUninterestedPost,
  });

  final Function cancleUninterestedPost;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black, // 테두리 색상
          width: 1.0, // 테두리 두께 (1px)
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Flexible(
              child: Text(
                '감사합니다. 보내주신 피드백은 피드를 개선하는데 사용됩니다.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.1,
                ),
              ),
            ),
            SizedBox(
              width: 77,
              height: 28,
              child: CommonBtn(
                isPurple: false,
                onPressFunc: () {
                  cancleUninterestedPost();
                },
                context: context,
                btnTitle: '취소',
                fontSize: 14,
              ),
            )
          ],
        ),
      ),
    );
  }
}
