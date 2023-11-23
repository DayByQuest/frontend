import 'package:flutter_dotenv/flutter_dotenv.dart';

class Interest {
  final String name;
  final String imageUrl;

  static String? IMAGE_BASE_URL = dotenv.env['IMAGE_BASE_URL'] ?? '';

  Interest({
    required this.name,
    required this.imageUrl,
  });

  factory Interest.fromJson(Map<String, dynamic> json) {
    return Interest(
      name: json['name'] ?? '',
      imageUrl: '${IMAGE_BASE_URL}${json['imageIdentifier']}' ?? '',
    );
  }
}
