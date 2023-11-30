import 'package:flutter/material.dart';

class CommonBtn extends StatelessWidget {
  const CommonBtn({
    super.key,
    required this.isPurple,
    required this.onPressFunc,
    required this.context,
    required this.btnTitle,
    this.fontSize = 22,
  });

  final String btnTitle;
  final bool isPurple;
  final Function onPressFunc;
  final BuildContext context;
  final double fontSize;

  @override
  Widget build(BuildContext _) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.zero),
              fixedSize: MaterialStateProperty.all(
                const Size.fromHeight(48),
              ),
              shape: MaterialStateProperty.all(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
              side: MaterialStateProperty.all(
                BorderSide(
                  color: isPurple ? Color(0xFF82589F) : Colors.black,
                ),
              ),
              backgroundColor: MaterialStateProperty.all(
                isPurple ? Color(0xFFD6A2E8) : null,
              ),
            ),
            onPressed: () async {
              onPressFunc();
            },
            child: SizedBox(
              width: 77,
              child: Text(
                btnTitle,
                style: TextStyle(
                  fontSize: fontSize,
                  color: isPurple ? Colors.white : Colors.black,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CommonIconBtn extends StatelessWidget {
  const CommonIconBtn({
    super.key,
    required this.isPurple,
    required this.onPressFunc,
    required this.context,
    required this.icon,
    this.iconSize = 22,
  });

  final bool isPurple;
  final Function onPressFunc;
  final BuildContext context;
  final double iconSize;
  final IconData icon;

  @override
  Widget build(BuildContext _) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all(
                const Size.fromHeight(48),
              ),
              shape: MaterialStateProperty.all(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
              side: MaterialStateProperty.all(
                BorderSide(
                  color: isPurple ? Color(0xFF82589F) : Colors.black,
                ),
              ),
              backgroundColor: MaterialStateProperty.all(
                isPurple ? Color(0xFFD6A2E8) : null,
              ),
            ),
            onPressed: () async {
              onPressFunc();
            },
            child: Icon(
              icon,
              size: iconSize,
              color: isPurple ? Colors.white : Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}


// Text(
//               btnTitle,
//               style: TextStyle(
//                 fontSize: fontSize,
//                 color: isPurple ? Colors.white : Colors.black,
//               ),
//             ),