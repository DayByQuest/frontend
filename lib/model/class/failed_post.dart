import 'package:flutter_application_1/model/class/post_image.dart';
import 'package:flutter_application_1/model/class/post_images.dart';

class FailedPost {
  final int id;
  final PostImages postImages;

  FailedPost({
    required this.id,
    required this.postImages,
  });

  factory FailedPost.fromJson(Map<String, dynamic> json) {
    return FailedPost(
      id: json['id'],
      postImages: PostImages(
        (json['imageIdentifiers'] as List<dynamic>)
            .map((imageJson) => PostImage(
                  imageUrl: imageJson,
                ))
            .toList(),
      ),
    );
  }
}
