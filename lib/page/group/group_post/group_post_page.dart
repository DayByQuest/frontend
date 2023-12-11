import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/class/post_images.dart';
import 'package:flutter_application_1/model/repository/group_repository.dart';
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
import 'group_post_page_model.dart';

class GroupPostPage extends StatelessWidget {
  final int groupId;

  const GroupPostPage({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) {
          return GroupPostViewModel(
            errorStatusProvider: context.read<ErrorStatusProvider>(),
            followStatusProvider: context.watch<FollowStatusProvider>(),
            postLikeStatusProvider: context.read<PostLikeStatusProvider>(),
            groupRepository: GroupRepositoty(),
            postRepository: PostRepository(),
            userRepository: UserRepository(),
            groupId: groupId,
          );
        },
        child: GroupPostView());
  }
}

class GroupPostView extends StatelessWidget {
  const GroupPostView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    GroupPostViewModel viewModel = context.read<GroupPostViewModel>();

    return Scaffold(
      appBar: BackSpaceAppBar(
        appBar: AppBar(),
        title: "그룹 게시물 목록 조회",
        isContextPopTrue: true,
      ),
      body: ListView(
        children: [
          PagedListView<int, Post>(
            shrinkWrap: true,
            primary: false,
            pagingController: viewModel.pagingController,
            builderDelegate: PagedChildBuilderDelegate<Post>(
              noItemsFoundIndicatorBuilder: (context) {
                return const ShowEmptyList(
                  content: '그룹 게시물이 없습니다.',
                );
              },
              itemBuilder: (context, post, index) =>
                  GroupPost(postIndex: index),
            ),
          ),
        ],
      ),
    );
  }
}

class GroupPost extends StatelessWidget {
  final int postIndex;

  const GroupPost({
    super.key,
    required this.postIndex,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 32;

    GroupPostViewModel viewModel = context.read<GroupPostViewModel>();
    Post post = context.watch<GroupPostViewModel>().postList[postIndex];
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

    void moveAuthorProfile() {
      context.push('/user-profile?username=${username}');
    }

    void follow() async {
      await viewModel.postFollow(username);
    }

    void unFollow() async {
      await viewModel.deleteFollow(username);
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
            clickAuthorTap: moveAuthorProfile,
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
