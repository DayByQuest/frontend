import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/class/feed.dart';
import 'package:flutter_application_1/model/class/group_post.dart';
import 'package:flutter_application_1/model/class/post.dart';
import 'package:flutter_application_1/model/class/post_image.dart';
import 'package:flutter_application_1/model/repository/group_repository.dart';
import 'package:flutter_application_1/model/repository/post_repository.dart';
import 'package:flutter_application_1/model/repository/user_repository.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class FeedViewModel with ChangeNotifier {
  final PostRepository _postRepository;
  final GroupRepositoty _groupRepositoty;
  final UserRepository _userRepository;

  final PagingController<int, Feed> _pagingController =
      PagingController(firstPageKey: -1);
  final List<Feed> feedList = [];
  bool _hasNextPage = true;
  int _lastId = -1;
  final int _limit = 10;
  bool _isClose = false;
  int groupCnt = 0;
  List<GroupPost> groupList = [];

  FeedViewModel({
    required PostRepository postRepository,
    required GroupRepositoty groupRepositoty,
    required UserRepository userRepository,
  })  : _postRepository = postRepository,
        _groupRepositoty = groupRepositoty,
        _userRepository = userRepository {
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
      }

      if (groupList.isEmpty) {
        final groupResult = await _postRepository.getRemoteGroupFeed();
        groupList.addAll(groupResult);
      }

      if (groupList.isNotEmpty) {
        GroupPost groupPost = groupList[0];
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
    } catch (e) {
      debugPrint("loadFeedList error: ${e.toString()}");
    }
  }

  Future<void> uninterestedPost(int postId, int index) async {
    try {
      await _postRepository.postRemoteDislike(postId);
      feedList[index].post?.unInterested = true;
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> cancelUninterestedPost(int postId, int index) async {
    try {
      await _postRepository.deleteRemoteDislike(postId);
      feedList[index].post?.unInterested = false;
      notifyListeners();
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
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> likePost(int postId, int index) async {
    try {
      await _postRepository.postRemoteLike(postId);
      feedList[index].post?.liked = true;
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      feedList[index].post?.liked = false;
    }
  }

  Future<void> cancelLikePost(int postId, int index) async {
    try {
      await _postRepository.deleteRemoteLike(postId);
      feedList[index].post?.liked = false;
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      feedList[index].post?.liked = true;
    }
  }

  Future<void> uninterestedGroupPost(int groupId, int index) async {
    try {
      await _postRepository.postRemoteGroupDislike(groupId);
      feedList[index].groupPost?.unInterested = true;
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> cancelUninterestedGroupPost(int groupId, int index) async {
    try {
      await _postRepository.deleteRemoteGroupDislike(groupId);
      feedList[index].groupPost?.unInterested = false;
      notifyListeners();
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
    } catch (e) {
      debugPrint('groupJoin: ${e.toString()}');
    }
  }

  Future<void> cancleGroupJoin(int groupId, int index) async {
    try {
      await _groupRepositoty.remoteDeleteGroupJoin(groupId);
      feedList[index].groupPost?.isJoin = false;
      notifyListeners();
    } catch (e) {
      debugPrint('groupJoin: ${e.toString()}');
    }
  }

  void setIsClose(bool isClose) {
    _isClose = isClose;
    notifyListeners();
  }

  Future<void> postFollow(String username, int index) async {
    try {
      if (!feedList[index].isPost) {
        return;
      }

      debugPrint("username:  $username");
      await _userRepository.postRemoteUserFollow(username);
      feedList[index].post!.author.following = true;
      debugPrint("postFollow:  교체!");
      notifyListeners();
    } catch (e) {
      debugPrint('postFollow error: ${e.toString()}');
    }
  }

  Future<void> deleteFollow(String username, index) async {
    try {
      if (!feedList[index].isPost) {
        return;
      }

      await _userRepository.deleteRemoteUserFollow(username);
      feedList[index].post!.author.following = false;
      notifyListeners();
    } catch (e) {
      debugPrint('deleteFollow error: ${e.toString()}');
    }
  }
}
