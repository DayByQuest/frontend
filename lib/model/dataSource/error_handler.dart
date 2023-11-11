import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

String statusErrorHandler(Response response) {
  String code = response.statusCode.toString();
  String message = response.statusMessage.toString();
  String errorMessage =
      'error status code: ${code} & error status message: ${message}';
  debugPrint(errorMessage);
  return errorMessage;
}

String commonErrorHandler(Response response) {
  String code = response.data.code.toString();
  String message = response.data.message.toString();
  String errorMessage = 'error code: ${code} & error message: ${message}';
  debugPrint(errorMessage);
  return errorMessage;
}
