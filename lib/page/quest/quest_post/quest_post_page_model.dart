import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/class/error_exception.dart';
import 'package:flutter_application_1/model/class/user.dart';
import 'package:flutter_application_1/model/repository/post_repository.dart';
import 'package:flutter_application_1/model/repository/quest_repository.dart';
import 'package:flutter_application_1/model/repository/user_repository.dart';
import 'package:flutter_application_1/provider/error_status_provider.dart';
import 'package:flutter_application_1/provider/follow_status_provider.dart';
import 'package:flutter_application_1/provider/postLike_status_provider%20copy.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../model/class/post.dart';
import '../../../model/class/post_image.dart';

class QuestPostViewModel with ChangeNotifier {
  final ErrorStatusProvider _errorStatusProvider;
  final FollowStatusProvider _followStatusProvider;
  final PostLikeStatusProvider _postLikeStatusProvider;
  final QuestRepository _questRepository;
  final UserRepository _userRepository;
  final PostRepository _postRepository;
  final int questId;

  final PagingController<int, Post> _pagingController =
      PagingController(firstPageKey: -1);
  final List<Post> postList = [];
  bool _hasNextPage = true;
  int _lastId = -1;
  final int _limit = 5;

  QuestPostViewModel({
    required QuestRepository questRepository,
    required UserRepository userRepository,
    required PostRepository postRepository,
    required this.questId,
    required errorStatusProvider,
    required followStatusProvider,
    required postLikeStatusProvider,
  })  : _questRepository = questRepository,
        _userRepository = userRepository,
        _postRepository = postRepository,
        _errorStatusProvider = errorStatusProvider,
        _followStatusProvider = followStatusProvider,
        _postLikeStatusProvider = postLikeStatusProvider {
    _pagingController.addPageRequestListener((int lastId) {
      loadQuestPostList(lastId);
    });
  }

  PagingController<int, Post> get pagingController => _pagingController;

  Future<void> loadQuestPostList(int lastId) async {
    if (!_hasNextPage) {
      return;
    }

    try {
      final result =
          await _questRepository.getQuestPostList(_limit, lastId, questId);
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
      _followStatusProvider.updateAllFollowingList(authorList);
      _postLikeStatusProvider.updateAllPostLikeList(newPostList);

      debugPrint("loadQuestPostList: 동작중! _lastId: $_lastId");
    } on ErrorException catch (e) {
      _errorStatusProvider.setErrorStatus(true, e.message);
    } catch (e) {
      debugPrint('loadQuestPostList error: ${e.toString()}');
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
    await _followStatusProvider.addFollowingUser(username);
  }

  Future<void> deleteFollow(String username) async {
    await _followStatusProvider.unFollowUser(username);
  }
}
