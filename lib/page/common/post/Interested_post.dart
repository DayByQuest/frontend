import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/class/post_image.dart';
import 'package:flutter_application_1/page/my_profile/my_post/my_post_page_model.dart';

import 'author_profile.dart';
import 'post_bar.dart';
import 'post_content.dart';
import 'post_image_view.dart';

class InterestedPost extends StatelessWidget {
  final String userImageUrl;
  final String username;
  final viewModel;
  final int postId;
  final int postIndex;
  final double width;
  final String content;
  final List<PostImage> postImageList;
  final int imageLength;
  final int curImageIndex;
  final bool isLike;
  final Function changeCurIdx;
  final Function changeLikePost;
  final Function clickAuthorTap;

  const InterestedPost(
      {super.key,
      required this.userImageUrl,
      required this.username,
      required this.viewModel,
      required this.postId,
      required this.postIndex,
      required this.width,
      required this.content,
      required this.postImageList,
      required this.imageLength,
      required this.curImageIndex,
      required this.isLike,
      required this.changeCurIdx,
      required this.changeLikePost,
      required this.clickAuthorTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AuthorProfile(
          userImageUrl: userImageUrl,
          username: username,
          viewModel: viewModel,
          postId: postId,
          postIndex: postIndex,
          clickAuthorTap: clickAuthorTap,
        ),
        const SizedBox(
          height: 8,
        ),
        PostContent(
          width: width,
          content: content,
        ),
        const SizedBox(
          height: 8,
        ),
        PostImageView(
          width: width,
          imageList: postImageList,
          imageLength: imageLength,
          changeCurIdx: changeCurIdx,
        ),
        PostBar(
          width: width,
          imageLength: imageLength,
          curImageIndex: curImageIndex,
          isLike: isLike,
          changeLikePost: changeLikePost,
        ),
      ],
    );
  }
}
