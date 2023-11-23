import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/repository/post_repository.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../model/class/post.dart';
import '../../../model/class/post_image.dart';

class MyPostViewModel with ChangeNotifier {
  final PostRepository _postRepository;
  final PagingController<int, Post> _pagingController =
      PagingController(firstPageKey: 0);
  final List<Post> postList = [];
  bool _hasNextPage = true;
  int _lastId = -1;
  final int _limit = 5;
  final username;

  MyPostViewModel({
    required PostRepository postRepository,
    required this.username,
  }) : _postRepository = postRepository {
    _pagingController.addPageRequestListener((int lastId) {
      debugPrint('lastId: $_lastId');
      loadPostList(_lastId);
    });
  }

  PagingController<int, Post> get pagingController => _pagingController;

  Future<void> loadPostList(int lastId) async {
    if (!_hasNextPage) {
      return;
    }

    try {
      final result = await _postRepository.getRemoteUserPost(_limit, lastId);
      final List<Post> newPostList = result.$1;
      _hasNextPage = result.$2;
      _lastId = result.$3;

      if (_hasNextPage) {
        _pagingController.appendPage(newPostList, _lastId);
      } else {
        _pagingController.appendLastPage(newPostList);
      }

      postList.addAll(newPostList);

      debugPrint("loadFollowerList: 동작중! _lastId: $_lastId");
      debugPrint(
          "newPostList[0]: ${newPostList[0].id}, ${newPostList[0].author}");
    } catch (e) {
      debugPrint('loadPostList error: ${e.toString()}');
    }
  }

  Future<void> uninterestedPost(int postId, int index) async {
    try {
      await _postRepository.postRemoteDislike(postId);
      postList[index].unInterested = true;
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> cancelUninterestedPost(int postId, int index) async {
    try {
      await _postRepository.deleteRemoteDislike(postId);
      postList[index].unInterested = false;
      notifyListeners();
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
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> likePost(int postId, int index) async {
    try {
      await _postRepository.postRemoteLike(postId);
      postList[index].liked = true;
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      postList[index].liked = false;
    }
  }

  Future<void> cancelLikePost(int postId, int index) async {
    try {
      await _postRepository.deleteRemoteLike(postId);
      postList[index].liked = false;
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      postList[index].liked = true;
    }
  }
}
