import 'package:flutter_application_1/model/class/group_post.dart';
import 'package:flutter_application_1/model/class/post.dart';

class Feed {
  final bool isPost;
  final Post? post;
  final GroupPost? groupPost;

  Feed.post({
    required this.isPost,
    required this.post,
  }) : groupPost = null;

  Feed.group({
    required this.isPost,
    required this.groupPost,
  }) : post = null;

  factory Feed.fromJson(Map<String, dynamic> json, bool isPost) {
    if (isPost) {
      return Feed.post(
        isPost: true,
        post: Post.fromJson(json),
      );
    } else {
      return Feed.group(
        isPost: false,
        groupPost: GroupPost.fromJson(json),
      );
    }
  }
}
