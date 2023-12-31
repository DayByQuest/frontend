import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/class/post_images.dart';
import 'package:flutter_application_1/model/repository/quest_repository.dart';
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
import '../../../model/repository/post_repository.dart';
import '../../common/Appbar.dart';
import '../../common/post/Interested_post.dart';
import '../../common/post/uninterested_post.dart';
import 'quest_post_page_model.dart';

class QuestPostPage extends StatelessWidget {
  final int questId;

  const QuestPostPage({
    super.key,
    required this.questId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) {
          return QuestPostViewModel(
            errorStatusProvider: context.read<ErrorStatusProvider>(),
            followStatusProvider: context.read<FollowStatusProvider>(),
            postLikeStatusProvider: context.read<PostLikeStatusProvider>(),
            postRepository: PostRepository(),
            userRepository: UserRepository(),
            questRepository: QuestRepository(),
            questId: questId,
          );
        },
        child: QuestPostView());
  }
}

class QuestPostView extends StatelessWidget {
  const QuestPostView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    QuestPostViewModel viewModel = context.read<QuestPostViewModel>();

    return Scaffold(
      appBar: BackSpaceAppBar(
        appBar: AppBar(),
        title: "퀘스트 게시물 조회",
        isContextPopTrue: true,
      ),
      body: PagedListView<int, Post>(
        pagingController: viewModel.pagingController,
        builderDelegate: PagedChildBuilderDelegate<Post>(
          noItemsFoundIndicatorBuilder: (context) {
            return ShowEmptyList(content: '퀘스트와 관련된 게시물이 없습니다');
          },
          itemBuilder: (context, post, index) => QuestPost(postIndex: index),
        ),
      ),
    );
  }
}

class QuestPost extends StatelessWidget {
  final int postIndex;

  const QuestPost({
    super.key,
    required this.postIndex,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 32;

    QuestPostViewModel viewModel = context.read<QuestPostViewModel>();
    Post post = context.watch<QuestPostViewModel>().postList[postIndex];
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
