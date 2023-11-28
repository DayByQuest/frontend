import 'package:flutter/material.dart';

Future<void> showMyDialog(
  BuildContext context,
  String title,
  String content,
  String leftBtnText,
  String rightBtnText,
  Function rightBtnFunc,
) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: title.isNotEmpty ? Text(title) : null,
        content: content.isNotEmpty
            ? Text(
                content,
                style: TextStyle(),
                textAlign: TextAlign.center,
              )
            : null,
        actions: <Widget>[
          leftBtnText.isNotEmpty
              ? TextButton(
                  child: Text(leftBtnText),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              : Container(),
          rightBtnText.isNotEmpty
              ? TextButton(
                  child: Text(rightBtnText),
                  onPressed: () async {
                    rightBtnFunc();
                    Navigator.of(context).pop();
                  },
                )
              : Container(),
        ],
      );
    },
  );
}
