import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/class/comment.dart';
import 'package:flutter_application_1/model/class/error_exception.dart';
import 'package:flutter_application_1/model/class/post.dart';
import 'package:flutter_application_1/model/class/post_image.dart';
import 'package:flutter_application_1/model/class/user.dart';
import 'package:flutter_application_1/model/repository/post_repository.dart';
import 'package:flutter_application_1/model/repository/user_repository.dart';
import 'package:flutter_application_1/page/common/Status.dart';
import 'package:flutter_application_1/provider/error_status_provider.dart';
import 'package:flutter_application_1/provider/follow_status_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class DetailViewModel with ChangeNotifier {
  final ErrorStatusProvider _errorStatusProvider;
  final FollowStatusProvider _followStatusProvider;
  final PostRepository _postRepository;
  final UserRepository _userRepository;

  final int postId;
  final PagingController<int, Comment> _pagingController =
      PagingController(firstPageKey: 0);

  final List<Comment> commentList = [];
  final int _limit = 10;
  late Post _post;
  bool hasQuest = false;
  bool _hasNextPage = true;
  int _lastId = -1;
  bool _isClose = false;
  Status status = Status.loading;
  static String? BASE_USER_NAME = dotenv.env['USER_NAME'] ?? '';

  DetailViewModel({
    required PostRepository postRepository,
    required UserRepository userRepository,
    required this.postId,
    required errorStatusProvider,
    required followStatusProvider,
  })  : _postRepository = postRepository,
        _userRepository = userRepository,
        _errorStatusProvider = errorStatusProvider,
        _followStatusProvider = followStatusProvider {
    _pagingController.addPageRequestListener((lastId) {
      loadCommentList(lastId);
    });
  }

  PagingController<int, Comment> get pagingController => _pagingController;
  Post get post => _post;
  bool get isClose => _isClose;

  void load() async {
    try {
      debugPrint("loding시작! postId: $postId");
      _post = await _postRepository.getRemoteDetailPost(postId);
      hasQuest = _post.quest != null;
      status = Status.loaded;
      notifyListeners();
      debugPrint("loding됨!");
    } on ErrorException catch (e) {
      _errorStatusProvider.setErrorStatus(true, e.message);
    } catch (e) {
      debugPrint('load error: ${e.toString()}');
    }
  }

  Future<void> loadCommentList(int lastId) async {
    if (!_hasNextPage) {
      return;
    }

    try {
      final commentResult =
          await _postRepository.getRemoteComment(postId, _limit, lastId);
      final List<Comment> newCommentList = commentResult.$1;
      _hasNextPage = commentResult.$2;
      _lastId = commentResult.$3;

      commentList.addAll(newCommentList);

      if (_hasNextPage) {
        _pagingController.appendPage(newCommentList, _lastId);
      } else {
        _pagingController.appendLastPage(newCommentList);
      }

      debugPrint("loadCommentList: 동작중! _lastId: $lastId");
    } on ErrorException catch (e) {
      _errorStatusProvider.setErrorStatus(true, e.message);
    } catch (e) {
      debugPrint("loadCommentList error: ${e.toString()}");
    }
  }

  Future<void> postFollow(String username) async {
    await _followStatusProvider.addFollowingUser(username);
  }

  Future<void> deleteFollow(String username) async {
    await _followStatusProvider.unFollowUser(username);
  }

  Future<void> uninterestedPost(int postId) async {
    try {
      await _postRepository.postRemoteDislike(postId);
      notifyListeners();
    } on ErrorException catch (e) {
      _errorStatusProvider.setErrorStatus(true, e.message);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> cancelUninterestedPost(int postId) async {
    try {
      await _postRepository.deleteRemoteDislike(postId);
      notifyListeners();
    } on ErrorException catch (e) {
      _errorStatusProvider.setErrorStatus(true, e.message);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> changeCurImageIndex(int nextImageIndex, int postId) async {
    try {
      _post.postImages.index = nextImageIndex;

      PostImage nextImage = _post.postImages.postImageList[nextImageIndex];
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
    try {
      await _postRepository.postRemoteLike(postId);
      _post.liked = true;
      notifyListeners();
    } on ErrorException catch (e) {
      _errorStatusProvider.setErrorStatus(true, e.message);
    } catch (e) {
      debugPrint(e.toString());
      _post.liked = false;
    }
  }

  Future<void> cancelLikePost(int postId) async {
    try {
      await _postRepository.deleteRemoteLike(postId);
      _post.liked = false;
      notifyListeners();
    } on ErrorException catch (e) {
      _errorStatusProvider.setErrorStatus(true, e.message);
    } catch (e) {
      debugPrint(e.toString());
      _post.liked = true;
    }
  }

  Future<void> postComment(int postId, String comment) async {
    try {
      await _postRepository.postRemoteComment(postId, comment);
      debugPrint('문자 입력!');
      User user = User(
          username: BASE_USER_NAME!, name: 'name', imageUrl: 'nothing.com');
      Comment newComment = Comment(author: user, id: 1, content: comment);
      commentList.add(newComment);
      _pagingController.itemList = commentList;
      debugPrint('문자 추가됨!: 길이: ${_pagingController.itemList?.length}');
      notifyListeners();
      //List<Comment> newCommentList = List.from([newComment]);
      //_pagingController.appendPage(newCommentList, _lastId);
    } on ErrorException catch (e) {
      _errorStatusProvider.setErrorStatus(true, e.message);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void setIsClose(bool isClose) {
    _isClose = isClose;
    notifyListeners();
  }
}
