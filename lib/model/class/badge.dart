import 'package:flutter_dotenv/flutter_dotenv.dart';

class Badge {
  final String _name;
  final String _imageUrl;
  final int _id;
  final String _acquiredAt;

  static String? IMAGE_BASE_URL = dotenv.env['IMAGE_BASE_URL'] ?? '';

  Badge(
      {required String name,
      required String imageUrl,
      required int id,
      required String acquiredAt})
      : _name = name,
        _imageUrl = imageUrl,
        _id = id,
        _acquiredAt = acquiredAt;

  String get name => _name;
  String get imageUrl => _imageUrl;
  int get id => _id;
  String get acquiredAt => _acquiredAt;

  factory Badge.fromJson(Map<String, dynamic> json) {
    return Badge(
      name: json['name'],
      imageUrl: '${IMAGE_BASE_URL}${json['imageIdentifier']}',
      id: json['id'],
      acquiredAt: json['acquiredAt'],
    );
  }
}
