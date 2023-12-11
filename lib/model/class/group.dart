import 'package:flutter_dotenv/flutter_dotenv.dart';

class Group {
  final int groupId;
  final String name;
  final String description;
  final String interest;
  final String imageUrl;
  int userCount;
  final bool isGroupManager;
  bool isGroupMember;
  bool isJoin;
  bool unInterested;

  static String? IMAGE_BASE_URL = dotenv.env['IMAGE_BASE_URL'] ?? '';

  Group({
    required this.groupId,
    required this.name,
    required this.description,
    required this.interest,
    required this.imageUrl,
    required this.userCount,
    required this.isGroupManager,
    required this.isGroupMember,
    this.isJoin = false,
    this.unInterested = false,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      groupId: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      interest: json['interest'],
      imageUrl: '${IMAGE_BASE_URL}${json['imageIdentifier']}',
      userCount: json['userCount'] ?? 0,
      isGroupManager: json['isGroupManager'] ?? false,
      isGroupMember: json['isGroupMember'] ?? false,
    );
  }
}
