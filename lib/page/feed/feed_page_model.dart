import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/class/error_exception.dart';
import 'package:flutter_application_1/model/class/feed.dart';
import 'package:flutter_application_1/model/class/group.dart';
import 'package:flutter_application_1/model/class/post.dart';
import 'package:flutter_application_1/model/class/post_image.dart';
import 'package:flutter_application_1/model/class/user.dart';
import 'package:flutter_application_1/model/repository/group_repository.dart';
import 'package:flutter_application_1/model/repository/post_repository.dart';
import 'package:flutter_application_1/model/repository/user_repository.dart';
import 'package:flutter_application_1/provider/error_status_provider.dart';
import 'package:flutter_application_1/provider/follow_status_provider.dart';
import 'package:flutter_application_1/provider/postLike_status_provider%20copy.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class FeedViewModel with ChangeNotifier {
  final ErrorStatusProvider _errorStatusProvider;
  final FollowStatusProvider followStatusProvider;
  final PostLikeStatusProvider _postLikeStatusProvider;
  final PostRepository _postRepository;
  final GroupRepositoty _groupRepositoty;

  final PagingController<int, Feed> _pagingController =
      PagingController(firstPageKey: -1);
  final List<Feed> feedList = [];
  bool _hasNextPage = true;
  int _lastId = -1;
  final int _limit = 10;
  bool _isClose = false;
  int groupCnt = 0;
  List<Group> groupList = [];

  FeedViewModel({
    required PostRepository postRepository,
    required GroupRepositoty groupRepositoty,
    required errorStatusProvider,
    required this.followStatusProvider,
    required postLikeStatusProvider,
  })  : _postRepository = postRepository,
        _groupRepositoty = groupRepositoty,
        _errorStatusProvider = errorStatusProvider,
        _postLikeStatusProvider = postLikeStatusProvider {
    _pagingController.addPageRequestListener((lastId) {
      loadFeedList(lastId);
    });
  }

  PagingController<int, Feed> get pagingController => _pagingController;
  bool get isClose => _isClose;

  Future<void> loadFeedList(int lastId) async {
    if (!_hasNextPage) {
      return;
    }

    try {
      final postResult = await _postRepository.getRemoteFeed(_limit, lastId);
      debugPrint("newFeedList.add: 동작중! _lastId: $lastId");
      final List<Feed> newFeedList = [];
      final List<Post> newPostList = postResult.$1;
      _hasNextPage = postResult.$2;
      _lastId = postResult.$3;

      for (Post post in newPostList) {
        newFeedList.add(Feed.post(isPost: true, post: post));

        User author = post.author;
        followStatusProvider.updateFollowingList(author);
        _postLikeStatusProvider.updatePostLikeList(post);
      }

      if (groupList.isEmpty) {
        final groupResult = await _postRepository.getRemoteGroupFeed();
        groupList.addAll(groupResult);
      }

      if (groupList.isNotEmpty) {
        Group groupPost = groupList[0];
        groupList.removeAt(0);
        newFeedList.add(Feed.group(isPost: false, groupPost: groupPost));
      }

      feedList.addAll(newFeedList);

      if (_hasNextPage) {
        _pagingController.appendPage(newFeedList, _lastId);
      } else {
        _pagingController.appendLastPage(newFeedList);
      }

      debugPrint("loadFeedList: 동작 종료! _lastId: $_lastId");
    } on ErrorException catch (e) {
      _errorStatusProvider.setErrorStatus(true, e.message);
    } catch (e) {
      debugPrint("loadFeedList error: ${e.toString()}");
    }
  }

  Future<void> uninterestedPost(int postId, int index) async {
    try {
      await _postRepository.postRemoteDislike(postId);
      feedList[index].post?.unInterested = true;
      notifyListeners();
    } on ErrorException catch (e) {
      _errorStatusProvider.setErrorStatus(true, e.message);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> cancelUninterestedPost(int postId, int index) async {
    try {
      await _postRepository.deleteRemoteDislike(postId);
      feedList[index].post?.unInterested = false;
      notifyListeners();
    } on ErrorException catch (e) {
      _errorStatusProvider.setErrorStatus(true, e.message);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> changeCurImageIndex(
      int nextImageIndex, int index, int postId) async {
    try {
      feedList[index].post?.postImages.index = nextImageIndex;

      PostImage nextImage =
          feedList[index].post!.postImages.postImageList[nextImageIndex];
      bool isSwipe = nextImage.isSwipe;

      if (!isSwipe) {
        await _postRepository.postRemoteSwipe(postId);
        nextImage.isSwipe = true;
      }
      notifyListeners();
      return;
    } on ErrorException catch (e) {
      _errorStatusProvider.setErrorStatus(true, e.message);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> likePost(int postId) async {
    await _postLikeStatusProvider.likePost(postId);
  }

  Future<void> cancelLikePost(int postId) async {
    await _postLikeStatusProvider.cancelLikePost(postId);
  }

  Future<void> uninterestedGroupPost(int groupId, int index) async {
    try {
      await _postRepository.postRemoteGroupDislike(groupId);
      feedList[index].groupPost?.unInterested = true;
      notifyListeners();
    } on ErrorException catch (e) {
      _errorStatusProvider.setErrorStatus(true, e.message);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> cancelUninterestedGroupPost(int groupId, int index) async {
    try {
      await _postRepository.deleteRemoteGroupDislike(groupId);
      feedList[index].groupPost?.unInterested = false;
      notifyListeners();
    } on ErrorException catch (e) {
      _errorStatusProvider.setErrorStatus(true, e.message);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> groupJoin(int groupId, int index) async {
    try {
      debugPrint('groupJoin: ${groupId}');
      await _groupRepositoty.remoteGroupJoin(groupId);
      feedList[index].groupPost?.isJoin = true;
      notifyListeners();
    } on ErrorException catch (e) {
      _errorStatusProvider.setErrorStatus(true, e.message);
    } catch (e) {
      debugPrint('groupJoin: ${e.toString()}');
    }
  }

  Future<void> cancleGroupJoin(int groupId, int index) async {
    try {
      await _groupRepositoty.remoteDeleteGroupJoin(groupId);
      feedList[index].groupPost?.isJoin = false;
      notifyListeners();
    } on ErrorException catch (e) {
      _errorStatusProvider.setErrorStatus(true, e.message);
    } catch (e) {
      debugPrint('groupJoin: ${e.toString()}');
    }
  }

  void setIsClose(bool isClose) {
    _isClose = isClose;
    notifyListeners();
  }

  Future<void> postFollow(String username) async {
    await followStatusProvider.addFollowingUser(username);
  }

  Future<void> deleteFollow(String username) async {
    await followStatusProvider.unFollowUser(username);
  }
}
