import 'package:flutter/material.dart';

void showSnackBarFun(BuildContext context, String message) {
  SnackBar snackBar = SnackBar(
    duration: Duration(milliseconds: 400),
    content: Text(
      message,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
    ),
    shape: Border.all(
      color: Colors.black,
    ),
    backgroundColor: Colors.white,
    dismissDirection: DismissDirection.up,
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.only(
      bottom: MediaQuery.of(context).size.height - 150,
      left: 10,
      right: 10,
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showSnackDetailPostBarFun(
    BuildContext context, int postId, Function cancelUninterestedPost) {
  SnackBar snackBar = SnackBar(
    action: SnackBarAction(
      label: '취소',
      onPressed: () {
        cancelUninterestedPost();
      },
      textColor: Colors.black,
    ),
    content: const Text(
      '감사합니다. 보내주신 피드백은 피드를 개선하는데 사용됩니다.',
      style: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
    ),
    shape: Border.all(
      color: Colors.black,
    ),
    backgroundColor: Colors.white,
    dismissDirection: DismissDirection.up,
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.only(
      bottom: MediaQuery.of(context).size.height - 150,
      left: 10,
      right: 10,
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
