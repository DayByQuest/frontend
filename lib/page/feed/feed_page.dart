import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/class/feed.dart';
import 'package:flutter_application_1/model/class/group_post.dart';
import 'package:flutter_application_1/model/class/post.dart';
import 'package:flutter_application_1/model/class/post_image.dart';
import 'package:flutter_application_1/model/class/post_images.dart';
import 'package:flutter_application_1/model/class/user.dart';
import 'package:flutter_application_1/model/dataSource/mock_data_source.dart';
import 'package:flutter_application_1/model/repository/group_repository.dart';
import 'package:flutter_application_1/model/repository/post_repository.dart';
import 'package:flutter_application_1/page/common/post/Interested_post.dart';
import 'package:flutter_application_1/page/common/post/uninterested_post.dart';
import 'package:flutter_application_1/page/feed/feed_page_model.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../common/Buttons.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FeedViewModel>(
      create: (_) {
        final FeedViewModel viewModel = FeedViewModel(
          postRepository: PostRepository(),
          groupRepositoty: GroupRepositoty(),
        );
        return viewModel;
      },
      child: FeedView(),
    );
  }
}

class FeedView extends StatelessWidget {
  const FeedView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    FeedViewModel viewModel = context.read<FeedViewModel>();

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 48.0,
            floating: true,
            title: Text("title"),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.check_box_outlined,
                  ),
                ),
              )
            ],
          ),
          PagedSliverList(
            pagingController: viewModel.pagingController,
            builderDelegate: PagedChildBuilderDelegate<Feed>(
              itemBuilder: (context, feed, index) => FeedItem(
                feedIndex: index,
                feed: feed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FeedItem extends StatelessWidget {
  final int feedIndex;
  final Feed feed;

  const FeedItem({
    super.key,
    required this.feedIndex,
    required this.feed,
  });

  @override
  Widget build(BuildContext context) {
    return feed.isPost
        ? PostItem(feedIndex: feedIndex)
        : GroupPostItem(feedIndex: feedIndex);
  }
}

class PostItem extends StatelessWidget {
  final int feedIndex;

  const PostItem({
    super.key,
    required this.feedIndex,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 32;

    FeedViewModel viewModel = context.read<FeedViewModel>();
    Post post = context.watch<FeedViewModel>().feedList[feedIndex].post!;
    User author = post.author;
    String username = author.username;
    String userImageUrl = author.imageUrl;
    bool isUnInterested = post.unInterested;
    int postId = post.id;
    String content = post.content;
    PostImages postImages = post.postImages;
    bool isLike = post.liked;
    List<PostImage> postImageList = List.from(postImages.postImageList);
    int curImageIndex = postImages.index;
    int imageLength = postImages.postImageList.length;
    bool isClose = context.watch<FeedViewModel>().isClose;

    void changeCurIdx(nextImageIndex) {
      viewModel.changeCurImageIndex(nextImageIndex, feedIndex, postId);
    }

    void changeLikePost() {
      isLike
          ? viewModel.cancelLikePost(postId, feedIndex)
          : viewModel.likePost(postId, feedIndex);
    }

    void cancelUninterestedPost() {
      viewModel.cancelUninterestedPost(postId, feedIndex);
    }

    void moveAuthorProfile() {
      context.push('/user-profile?username=${username}');
    }

    void moveDetailPage() {
      context.push('/detail?postId=$postId');
    }

    void setClose(bool setClose) {
      viewModel.setIsClose(setClose);
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AnimatedCrossFade(
        duration: const Duration(milliseconds: 300),
        firstChild: InkWell(
          onTap: () {
            moveDetailPage();
            setClose(true);
          },
          child: InterestedPost(
            userImageUrl: userImageUrl,
            username: username,
            viewModel: viewModel,
            postId: postId,
            postIndex: feedIndex,
            width: width,
            content: content,
            postImageList: postImageList,
            imageLength: imageLength,
            curImageIndex: curImageIndex,
            isLike: isLike,
            changeCurIdx: changeCurIdx,
            changeLikePost: changeLikePost,
            clickAuthorTap: moveAuthorProfile,
            isClose: isClose,
            setClose: setClose,
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

class GroupPostItem extends StatelessWidget {
  final int feedIndex;

  const GroupPostItem({
    super.key,
    required this.feedIndex,
  });

  @override
  Widget build(BuildContext context) {
    MenuController menu = MenuController();
    FeedViewModel viewModel = context.read<FeedViewModel>();
    GroupPost groupPost =
        context.watch<FeedViewModel>().feedList[feedIndex].groupPost!;
    bool isJoin = groupPost.isJoin;
    int groupId = groupPost.groupId;
    bool isUnInterested = groupPost.unInterested;
    String groupName = groupPost.name;
    String groupImage = groupPost.imageUrl;
    bool isClose = context.watch<FeedViewModel>().isClose;

    void changeJoinGroup() {
      isJoin
          ? viewModel.cancleGroupJoin(groupId, feedIndex)
          : viewModel.groupJoin(groupId, feedIndex);
    }

    void uninterestedGroup() {
      viewModel.uninterestedGroupPost(groupId, feedIndex);
    }

    void cancelUninterestedGroup() {
      viewModel.cancelUninterestedGroupPost(groupId, feedIndex);
    }

    void setClose(bool setClose) {
      viewModel.setIsClose(setClose);
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: AnimatedCrossFade(
        duration: const Duration(milliseconds: 300),
        firstChild: Column(
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      SizedBox(
                        width: 48,
                        height: 48,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            groupImage,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          groupName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                SizedBox(
                  width: 78,
                  height: 28,
                  child: CommonBtn(
                    isPurple: !isJoin,
                    onPressFunc: changeJoinGroup,
                    context: context,
                    btnTitle: isJoin ? "탈퇴" : "가입",
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                SubmenuButton(
                  controller: menu,
                  onOpen: () {
                    if (isClose) {
                      menu.close();
                      setClose(false);
                    }
                  },
                  alignmentOffset: const Offset(-275, 0),
                  menuStyle: const MenuStyle(
                      alignment: Alignment.bottomRight,
                      backgroundColor: MaterialStatePropertyAll(
                          Color.fromARGB(255, 255, 255, 255)),
                      side: MaterialStatePropertyAll(
                        BorderSide(),
                      )),
                  style: const ButtonStyle(
                    padding: MaterialStatePropertyAll(
                      EdgeInsets.all(0),
                    ),
                    minimumSize: MaterialStatePropertyAll(Size(28, 28)),
                  ),
                  menuChildren: [
                    MenuItemButton(
                      onPressed: uninterestedGroup,
                      child: Container(
                        width: 252,
                        height: 48,
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        margin: const EdgeInsets.all(0),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '이 그룹에 관심 없음',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Icon(Icons.block)
                          ],
                        ),
                      ),
                    ),
                  ],
                  child: Container(
                    width: 28,
                    height: 28,
                    child: Icon(
                      Icons.more_horiz,
                      size: 28,
                    ),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '저희를 따라와보세요!',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
          ],
        ),
        secondChild: UninterestedPost(
          cancleUninterestedPost: cancelUninterestedGroup,
        ),
        crossFadeState: isUnInterested
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
      ),
    );
  }
}
