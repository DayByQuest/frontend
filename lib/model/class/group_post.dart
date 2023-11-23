import 'package:flutter_dotenv/flutter_dotenv.dart';

class GroupPost {
  final int groupId;
  final String name;
  final String description;
  final String imageUrl;
  final int userCount;
  bool isJoin;
  bool unInterested;
  static String? IMAGE_BASE_URL = dotenv.env['IMAGE_BASE_URL'] ?? '';

  GroupPost({
    required this.groupId,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.userCount,
    this.isJoin = false,
    this.unInterested = false,
  });

  factory GroupPost.fromJson(Map<String, dynamic> json) {
    return GroupPost(
      groupId: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: '${IMAGE_BASE_URL}${json['imageIdentifier']}',
      userCount: json['userCount'] ?? 0,
    );
  }
}
