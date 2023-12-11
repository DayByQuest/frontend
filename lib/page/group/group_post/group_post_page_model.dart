import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/class/error_exception.dart';
import 'package:flutter_application_1/model/class/user.dart';
import 'package:flutter_application_1/model/repository/group_repository.dart';
import 'package:flutter_application_1/model/repository/post_repository.dart';
import 'package:flutter_application_1/model/repository/user_repository.dart';
import 'package:flutter_application_1/provider/error_status_provider.dart';
import 'package:flutter_application_1/provider/follow_status_provider.dart';
import 'package:flutter_application_1/provider/postLike_status_provider%20copy.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../model/class/post.dart';
import '../../../model/class/post_image.dart';

class GroupPostViewModel with ChangeNotifier {
  final ErrorStatusProvider _errorStatusProvider;
  final FollowStatusProvider followStatusProvider;
  final PostLikeStatusProvider _postLikeStatusProvider;
  final PostRepository _postRepository;
  final GroupRepositoty _groupRepository;
  final UserRepository _userRepository;
  final PagingController<int, Post> _pagingController =
      PagingController(firstPageKey: -1);
  final List<Post> postList = [];
  final int groupId;
  bool _hasNextPage = true;
  int _lastId = -1;
  final int _limit = 5;

  GroupPostViewModel({
    required GroupRepositoty groupRepository,
    required PostRepository postRepository,
    required UserRepository userRepository,
    required this.groupId,
    required errorStatusProvider,
    required this.followStatusProvider,
    required postLikeStatusProvider,
  })  : _groupRepository = groupRepository,
        _postRepository = postRepository,
        _userRepository = userRepository,
        _errorStatusProvider = errorStatusProvider,
        _postLikeStatusProvider = postLikeStatusProvider {
    _pagingController.addPageRequestListener((int lastId) {
      debugPrint('lastId: $lastId');
      loadPostList(lastId);
    });
  }

  PagingController<int, Post> get pagingController => _pagingController;

  Future<void> loadPostList(int lastId) async {
    if (!_hasNextPage) {
      return;
    }

    try {
      final result =
          await _groupRepository.getRemoteGroupPost(_limit, lastId, groupId);
      final List<Post> newPostList = result.$1;
      _hasNextPage = result.$2;
      _lastId = result.$3;

      if (_hasNextPage) {
        _pagingController.appendPage(newPostList, _lastId);
      } else {
        _pagingController.appendLastPage(newPostList);
      }

      postList.addAll(newPostList);

      List<User> authorList = newPostList.map((post) => post.author).toList();
      followStatusProvider.updateAllFollowingList(authorList);
      _postLikeStatusProvider.updateAllPostLikeList(newPostList);

      debugPrint("loadFollowerList: 동작중! _lastId: $_lastId");
      debugPrint(
          "newPostList[0]: ${newPostList[0].id}, ${newPostList[0].author}");
    } on ErrorException catch (e) {
      _errorStatusProvider.setErrorStatus(true, e.message);
    } catch (e) {
      debugPrint('loadPostList error: ${e.toString()}');
    }
  }

  Future<void> uninterestedPost(int postId, int index) async {
    try {
      await _postRepository.postRemoteDislike(postId);
      postList[index].unInterested = true;
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
      postList[index].unInterested = false;
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
      postList[index].postImages.index = nextImageIndex;
      PostImage nextImage =
          postList[index].postImages.postImageList[nextImageIndex];
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

  Future<void> postFollow(String username) async {
    await followStatusProvider.addFollowingUser(username);
  }

  Future<void> deleteFollow(String username) async {
    await followStatusProvider.unFollowUser(username);
  }
}
