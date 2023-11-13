import 'package:flutter_dotenv/flutter_dotenv.dart';

class PostImage {
  String imageUrl;
  bool isSwipe;
  static String? IMAGE_BASE_URL = dotenv.env['IMAGE_BASE_URL'] ?? '';

  PostImage({required this.imageUrl, bool? isSwipe})
      : isSwipe = isSwipe ?? false;

  factory PostImage.fromJson(Map<String, dynamic> json) {
    return PostImage(
      imageUrl: '${IMAGE_BASE_URL}${json['imageIdentifier']}',
      isSwipe: json['isSwipe'] ?? false,
    );
  }
}
