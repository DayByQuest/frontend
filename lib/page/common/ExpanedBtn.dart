import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ExpandedBtn extends StatelessWidget {
  const ExpandedBtn({
    super.key,
    required this.isShow,
    required this.onPressFunc,
    required this.context,
    required this.btnTitle,
  });

  final bool isShow;
  final Function onPressFunc;
  final BuildContext context;
  final String btnTitle;

  @override
  Widget build(_) {
    return Row(
      children: [
        Expanded(
          child: FilledButton(
            onPressed: isShow
                ? () async {
                    await onPressFunc();
                    context.pop(true);
                  }
                : null,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                isShow ? const Color(0xFFD6A2E8) : Colors.grey,
              ),
            ),
            child: Text(
              btnTitle,
              style: TextStyle(),
            ),
          ),
        ),
      ],
    );
  }
}
