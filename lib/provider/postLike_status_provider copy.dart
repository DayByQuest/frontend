import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/class/error_exception.dart';
import 'package:flutter_application_1/model/class/post.dart';
import 'package:flutter_application_1/model/repository/post_repository.dart';
import 'package:flutter_application_1/provider/error_status_provider.dart';

class PostLikeStatusProvider with ChangeNotifier {
  final ErrorStatusProvider _errorStatusProvider;
  final PostRepository _postRepository;
  final List<int> _postLikeList = [];

  PostLikeStatusProvider({
    required PostRepository postRepository,
    required errorStatusProvider,
  })  : _errorStatusProvider = errorStatusProvider,
        _postRepository = postRepository;

  bool hasLikePost(int postId) {
    bool hasLikePost = _postLikeList.contains(postId);

    return hasLikePost;
  }

  void updatePostLikeList(Post post) {
    if (!post.liked || hasLikePost(post.id)) {
      return;
    }

    _postLikeList.add(post.id);
    notifyListeners();
    return;
  }

  void updateAllPostLikeList(List<Post> postList) {
    for (Post post in postList) {
      updatePostLikeList(post);
    }

    return;
  }

  Future<void> likePost(int postId) async {
    if (hasLikePost(postId)) {
      return;
    }

    try {
      await _postRepository.postRemoteLike(postId);
      _postLikeList.add(postId);
      notifyListeners();
    } on ErrorException catch (e) {
      _errorStatusProvider.setErrorStatus(true, e.message);
    }

    return;
  }

  Future<void> cancelLikePost(int postId) async {
    if (!hasLikePost(postId)) {
      return;
    }

    try {
      await _postRepository.deleteRemoteLike(postId);
      _postLikeList.remove(postId);
      notifyListeners();
    } on ErrorException catch (e) {
      _errorStatusProvider.setErrorStatus(true, e.message);
    }

    return;
  }
}
