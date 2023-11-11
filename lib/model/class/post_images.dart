import 'package:flutter_application_1/model/class/post_image.dart';

class PostImages {
  final List<PostImage> postImageList;
  int index;

  PostImages(this.postImageList, {int index = 0}) : index = index;
}
