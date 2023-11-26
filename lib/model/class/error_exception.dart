class ErrorException implements Exception {
  final String code;
  final String message;
  final List<String> fields;

  ErrorException(
      {required this.code, required this.message, required this.fields});
}
