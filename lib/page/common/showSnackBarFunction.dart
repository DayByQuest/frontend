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
