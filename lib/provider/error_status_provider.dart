import 'package:flutter/material.dart';

class ErrorStatusProvider with ChangeNotifier {
  bool _errorStatus = false;
  String _errorMessage = '';

  bool get errorStatus => _errorStatus;
  String get errorMessage => _errorMessage;

  void setErrorStatus(bool status, String message) {
    _errorStatus = status;
    _errorMessage = message;
    notifyListeners();
  }
}
