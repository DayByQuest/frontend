import 'package:flutter_application_1/model/class/post_image.dart';
import 'package:flutter_application_1/model/class/post_images.dart';
import 'package:flutter_application_1/model/class/user.dart';

class Post {
  final User author;
  final int id;
  final String content;
  bool liked;
  final PostImages postImages;

  // 관심없음 유무를 확인할 수 있다. true라면 관심없음 표기.
  bool unInterested;

  Post({
    required this.author,
    required this.id,
    required this.content,
    this.liked = false,
    this.unInterested = false,
    required this.postImages,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      author: User.fromJson(json['author']),
      id: json['id'],
      content: json['content'],
      liked: json['liked'] ?? false,
      postImages: PostImages(
        (json['images'] as List<dynamic>)
            .map((imageJson) => PostImage.fromJson(imageJson))
            .toList(),
      ),
    );
  }
}
