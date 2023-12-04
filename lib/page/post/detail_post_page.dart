import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/class/comment.dart';
import 'package:flutter_application_1/model/class/post.dart';
import 'package:flutter_application_1/model/class/post_image.dart';
import 'package:flutter_application_1/model/class/post_images.dart';
import 'package:flutter_application_1/model/class/quest.dart';
import 'package:flutter_application_1/model/class/user.dart';
import 'package:flutter_application_1/model/dataSource/mock_data_source.dart';
import 'package:flutter_application_1/model/repository/post_repository.dart';
import 'package:flutter_application_1/model/repository/user_repository.dart';
import 'package:flutter_application_1/page/common/Appbar.dart';
import 'package:flutter_application_1/page/common/Buttons.dart';
import 'package:flutter_application_1/page/common/Loding.dart';
import 'package:flutter_application_1/page/common/Status.dart';
import 'package:flutter_application_1/page/common/post/post_bar.dart';
import 'package:flutter_application_1/page/common/post/post_content.dart';
import 'package:flutter_application_1/page/common/post/post_image_view.dart';
import 'package:flutter_application_1/page/post/detail_post_page_model.dart';
import 'package:flutter_application_1/provider/error_status_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../common/author_profile_view.dart';

class DetailPage extends StatelessWidget {
  final int postId;

  const DetailPage({
    super.key,
    required this.postId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DetailViewModel>(
      create: (_) {
        final DetailViewModel viewModel = DetailViewModel(
          errorStatusProvider: context.read<ErrorStatusProvider>(),
          postRepository: PostRepository(),
          userRepository: UserRepository(),
          postId: postId,
        );
        return viewModel;
      },
      child: DetailView(
        postId: postId,
      ),
    );
  }
}

class DetailView extends StatelessWidget {
  const DetailView({
    super.key,
    required this.postId,
  });

  final int postId;

  @override
  Widget build(BuildContext context) {
    final DetailViewModel viewModel = context.read<DetailViewModel>();
    bool isLoading = context.watch<DetailViewModel>().status == Status.loading;

    void postCommnet(String comment) {
      viewModel.postComment(postId, comment);
    }

    if (isLoading) {
      viewModel.load();
      return Loading(context: context);
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: BackSpaceAppBar(
            appBar: AppBar(), title: '상세페이지', isContextPopTrue: true),
        body: DetailViewBody(),
        bottomSheet: CommentInput(postCommnet: postCommnet),
      ),
    );
  }
}

class DetailViewBody extends StatelessWidget {
  const DetailViewBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final DetailViewModel viewModel = context.watch<DetailViewModel>();
    bool isLoading = context.watch<DetailViewModel>().status == Status.loading;

    double width = MediaQuery.of(context).size.width - 32;
    Post post = context.watch<DetailViewModel>().post;
    int postId = post.id;
    User author = post.author;
    String authorProfileImage = author.imageUrl;
    String authorUserName = author.username;
    String authorName = author.name;
    bool isFollowing = author.following;
    bool isClose = context.watch<DetailViewModel>().isClose;

    String content = post.content;
    PostImages postImages = post.postImages;
    List<PostImage> postImageList = List.from(postImages.postImageList);
    int curImageIndex = postImages.index;
    int imageLength = postImages.postImageList.length;
    bool isLike = post.liked;
    // imageList imageLength changeCurIdx

    void follow() async {
      await viewModel.postFollow(authorUserName);
    }

    void unFollow() async {
      await viewModel.deleteFollow(authorUserName);
    }

    void clickFollowBtn() {
      if (isFollowing) {
        unFollow();
        return;
      }

      follow();
    }

    void cancelUninterestedPost() {
      viewModel.cancelUninterestedPost(postId);
    }

    Future<void> uninterestedPost() async {
      await viewModel.uninterestedPost(postId);
    }

    void setClose(bool setClose) {
      viewModel.setIsClose(setClose);
    }

    void changeCurIdx(nextImageIndex) {
      viewModel.changeCurImageIndex(nextImageIndex, postId);
    }

    void changeLikePost() {
      isLike ? viewModel.cancelLikePost(postId) : viewModel.likePost(postId);
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                AuthorProfileView(
                  authorProfileImage: authorProfileImage,
                  authorUserName: authorUserName,
                  authorName: authorName,
                  isFollowing: isFollowing,
                  postId: postId,
                  clickFollowBtn: clickFollowBtn,
                  cancelUninterestedPost: cancelUninterestedPost,
                  uninterestedPost: uninterestedPost,
                  isClose: isClose,
                  setClose: setClose,
                ),
                const SizedBox(
                  height: 8,
                ),
                QuestInforView(),
                const SizedBox(
                  height: 8,
                ),
                ContentView(width: width, content: content),
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
                SizedBox(
                  height: 16,
                ),
                Divider(
                  color: Colors.black,
                  height: 1,
                ),
              ],
            ),
          ),
          PagedSliverList<int, Comment>(
            pagingController: viewModel.pagingController,
            builderDelegate: PagedChildBuilderDelegate<Comment>(
              itemBuilder: (context, comment, index) => CommentItem(
                index: index,
                comment: comment,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 80,
            ),
          ),
        ],
      ),
    );
  }
}

class CommentItem extends StatelessWidget {
  final int index;
  final Comment comment;

  const CommentItem({
    super.key,
    required this.index,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    String content = comment.content;
    User author = comment.author;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 16,
        ),
        RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style.copyWith(
                  fontSize: 14.0,
                  color: Colors.black, // 검은색 글씨
                  decoration: TextDecoration.none, // 밑줄 없음
                ),
            children: [
              TextSpan(
                text: '${author.username}: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: content,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ContentView extends StatelessWidget {
  const ContentView({
    super.key,
    required this.width,
    required this.content,
  });

  final double width;
  final String content;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Text(
        content,
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }
}

class QuestInforView extends StatelessWidget {
  const QuestInforView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool hasQuest = context.watch<DetailViewModel>().hasQuest;

    if (!hasQuest) {
      return Container();
    }

    Post post = context.watch<DetailViewModel>().post;
    Quest quest = post.quest!;
    String questTitle = quest.title;
    String questState = quest.state;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          questTitle,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        QuestStatusView(
          questStatus: questState,
        ),
      ],
    );
  }
}

class CommentInput extends StatelessWidget {
  Function postCommnet;

  CommentInput({
    Key? key,
    required this.postCommnet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _textEditingController = TextEditingController();

    return TextField(
      controller: _textEditingController,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: '댓글을 입력해주세요.',
      ),
      onSubmitted: (value) {
        postCommnet(value);
        _textEditingController.clear();
      },
    );
  }
}

class QuestStatusView extends StatelessWidget {
  final String questStatus;
  final String FAIL = 'FAIL';
  final String SUCCESS = 'SUCCESS';
  final String JUDGE = 'NEED_CHECK';

  const QuestStatusView({
    super.key,
    required this.questStatus,
  });

  @override
  Widget build(BuildContext context) {
    if (questStatus == FAIL) {
      return const Row(
        children: [
          Icon(
            Icons.do_disturb,
            color: Colors.red,
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            "실패",
          ),
        ],
      );
    }

    if (questStatus == SUCCESS) {
      return const Row(
        children: [
          Icon(
            Icons.check,
            color: Colors.purple,
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            "성공",
          ),
        ],
      );
    }

    return const Row(
      children: [
        Icon(
          Icons.pause_circle_outlined,
          color: Colors.black,
        ),
        SizedBox(
          width: 8,
        ),
        Text(
          "판정 중",
        ),
      ],
    );
  }
}
