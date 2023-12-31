import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/class/post_images.dart';
import 'package:flutter_application_1/model/repository/user_repository.dart';
import 'package:flutter_application_1/page/common/empty_list.dart';
import 'package:flutter_application_1/provider/error_status_provider.dart';
import 'package:flutter_application_1/provider/follow_status_provider.dart';
import 'package:flutter_application_1/provider/postLike_status_provider%20copy.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../../model/class/post.dart';
import '../../../model/class/post_image.dart';
import '../../../model/class/user.dart';
import '../../../model/dataSource/mock_data_source.dart';
import '../../../model/repository/post_repository.dart';
import '../../common/Appbar.dart';
import '../../common/post/Interested_post.dart';
import '../../common/post/uninterested_post.dart';
import 'my_post_page_model.dart';

class MyPostPage extends StatelessWidget {
  final String username;

  const MyPostPage({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) {
          return MyPostViewModel(
            errorStatusProvider: context.read<ErrorStatusProvider>(),
            followStatusProvider: context.read<FollowStatusProvider>(),
            postLikeStatusProvider: context.read<PostLikeStatusProvider>(),
            postRepository: PostRepository(),
            userRepository: UserRepository(),
            username: username,
          );
        },
        child: MyPostView());
  }
}

class MyPostView extends StatelessWidget {
  const MyPostView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    MyPostViewModel viewModel = context.read<MyPostViewModel>();

    return Scaffold(
      appBar: BackSpaceAppBar(
        appBar: AppBar(),
        title: "게시물",
        isContextPopTrue: true,
      ),
      body: PagedListView<int, Post>(
        pagingController: viewModel.pagingController,
        builderDelegate: PagedChildBuilderDelegate<Post>(
          noItemsFoundIndicatorBuilder: (context) {
            return ShowEmptyList(content: '내 게시물이 없습니다.');
          },
          itemBuilder: (context, post, index) => MyPost(postIndex: index),
        ),
      ),
    );
  }
}

class MyPost extends StatelessWidget {
  final int postIndex;

  const MyPost({
    super.key,
    required this.postIndex,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 32;

    MyPostViewModel viewModel = context.read<MyPostViewModel>();
    Post post = context.watch<MyPostViewModel>().postList[postIndex];
    User author = post.author;
    String username = author.username;
    String userImageUrl = author.imageUrl;
    bool isFollowing = context.watch<FollowStatusProvider>().hasUser(username);
    bool isUnInterested = post.unInterested;
    int postId = post.id;
    String content = post.content;
    PostImages postImages = post.postImages;
    bool isLike = context.watch<PostLikeStatusProvider>().hasLikePost(postId);
    List<PostImage> postImageList = List.from(postImages.postImageList);
    int curImageIndex = postImages.index;
    int imageLength = postImages.postImageList.length;

    void changeCurIdx(nextImageIndex) {
      viewModel.changeCurImageIndex(nextImageIndex, postIndex, postId);
    }

    void changeLikePost() {
      isLike ? viewModel.cancelLikePost(postId) : viewModel.likePost(postId);
    }

    void cancelUninterestedPost() {
      viewModel.cancelUninterestedPost(postId, postIndex);
    }

    void moveDetailPage() {
      debugPrint('moveDetailPage postId: $postId');
      context.push('/detail?postId=$postId');
    }

    void follow() async {
      await viewModel.postFollow(username, postIndex);
    }

    void unFollow() async {
      await viewModel.deleteFollow(username, postIndex);
    }

    void clickFollowBtn() {
      if (isFollowing) {
        unFollow();
        return;
      }

      follow();
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AnimatedCrossFade(
        duration: const Duration(milliseconds: 300),
        firstChild: InkWell(
          onTap: () {
            moveDetailPage();
          },
          child: InterestedPost(
            userImageUrl: userImageUrl,
            username: username,
            viewModel: viewModel,
            postId: postId,
            postIndex: postIndex,
            width: width,
            content: content,
            postImageList: postImageList,
            imageLength: imageLength,
            curImageIndex: curImageIndex,
            isLike: isLike,
            changeCurIdx: changeCurIdx,
            changeLikePost: changeLikePost,
            clickAuthorTap: () {},
            isClose: false,
            setClose: () {},
            isFollowing: isFollowing,
            clickFollowBtn: clickFollowBtn,
          ),
        ),
        secondChild: UninterestedPost(
          cancleUninterestedPost: cancelUninterestedPost,
        ),
        crossFadeState: isUnInterested
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
      ),
    );
  }
}
