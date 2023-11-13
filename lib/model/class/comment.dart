import 'package:flutter_application_1/model/class/user.dart';

class Comment {
  final User author;
  final int id;
  final String content;

  Comment({
    required this.author,
    required this.id,
    required this.content,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      author: User.fromJson(json['author']),
      id: json['id'],
      content: json['content'],
    );
  }
}

class CommentResponse {
  final List<Comment> comments;
  final int lastId;

  CommentResponse({
    required this.comments,
    required this.lastId,
  });

  factory CommentResponse.fromJson(Map<String, dynamic> json) {
    return CommentResponse(
      comments: (json['comments'] as List<dynamic>)
          .map((commentJson) => Comment.fromJson(commentJson))
          .toList(),
      lastId: json['lastId'],
    );
  }
}
