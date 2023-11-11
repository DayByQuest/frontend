import 'package:flutter_dotenv/flutter_dotenv.dart';

class User {
  final String _username;
  final String _name;
  final String _imageUrl;
  final int _followingCount;
  final int _followerCount;
  final int _postCount;
  final bool _blocking;
  bool following;
  bool isDelete;

  static String? IMAGE_BASE_URL = dotenv.env['IMAGE_BASE_URL'] ?? '';

  User({
    required String username,
    required String name,
    required String imageUrl,
    int? followingCount,
    int? followerCount,
    int? postCount,
    bool? blocking,
    bool? follwing,
    bool? isDelete,
  })  : _username = username,
        _name = name,
        _imageUrl = imageUrl,
        _followingCount = followingCount ?? 0,
        _followerCount = followerCount ?? 0,
        _postCount = postCount ?? 0,
        _blocking = blocking ?? false,
        following = follwing ?? false,
        isDelete = isDelete ?? false;

  String get username => _username;
  String get name => _name;
  String get imageUrl => _imageUrl;
  int get followingCount => _followingCount;
  int get followerCount => _followerCount;
  int get postCount => _postCount;
  bool get blocking => _blocking;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        username: json['username'],
        name: json['name'],
        imageUrl: '${IMAGE_BASE_URL}${json['imageIdentifier']}',
        followingCount: json['followingCount'] ?? 0,
        followerCount: json['followerCount'] ?? 0,
        postCount: json['postCount'] ?? 0,
        blocking: json['blocking'] ?? false);
  }
}
