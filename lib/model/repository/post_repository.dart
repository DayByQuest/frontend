import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/model/class/comment.dart';
import 'package:flutter_application_1/model/class/group.dart';
import 'package:image_picker_plus/image_picker_plus.dart';

import '../class/post.dart';
import '../dataSource/remote_data_source.dart';

class PostRepository {
  final RemoteDataSource _RemoteDataSource;

  PostRepository({RemoteDataSource? remoteDataSource})
      : _RemoteDataSource = remoteDataSource ?? getIt.get<RemoteDataSource>();

  Future<(List<Post> userPosts, bool hasNextPage, int lastId)>
      getRemoteUserPost(int limit, int lastId) async {
    try {
      return await _RemoteDataSource.getUserPost(limit, lastId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> postRemoteLike(int postId) async {
    try {
      await _RemoteDataSource.postLike(postId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteRemoteLike(int postId) async {
    try {
      await _RemoteDataSource.deleteLike(postId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> postRemoteDislike(int postId) async {
    try {
      await _RemoteDataSource.postDislike(postId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteRemoteDislike(int postId) async {
    try {
      await _RemoteDataSource.deleteDislike(postId);
    } catch (e) {
      debugPrint('에러 dio 감지! throwError rethrow');
      rethrow;
    }
  }

  Future<void> postRemoteSwipe(int postId) async {
    try {
      await _RemoteDataSource.postSwipe(postId);
    } catch (e) {
      rethrow;
    }
  }

  Future<(List<Post>, bool hasNextPage, int lastId)> getRemoteFeed(
      int limit, int lastId) async {
    try {
      return await _RemoteDataSource.getFeed(limit, lastId);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Group>> getRemoteGroupFeed() async {
    try {
      return await _RemoteDataSource.getGroupFeed();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> postRemoteGroupDislike(int groupId) async {
    try {
      await _RemoteDataSource.postGroupDislike(groupId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteRemoteGroupDislike(int groupId) async {
    try {
      await _RemoteDataSource.deleteDislike(groupId);
    } catch (e) {
      rethrow;
    }
  }

  Future<Post> getRemoteDetailPost(int postId) async {
    try {
      return await _RemoteDataSource.getDetailPost(postId);
    } catch (e) {
      rethrow;
    }
  }

  Future<(List<Comment>, bool hasNextPage, int lastId)> getRemoteComment(
      int postId, int limit, int lastId) async {
    try {
      return await _RemoteDataSource.getComment(postId, limit, lastId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> postRemoteComment(int postId, String comment) async {
    try {
      await _RemoteDataSource.postComment(postId, comment);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> postCreatePost(List<SelectedByte> selectedByte, String content,
      {int? questId}) async {
    try {
      await _RemoteDataSource.postCreatePost(
        selectedByte,
        content,
        questId: questId,
      );
    } catch (e) {
      rethrow;
    }
  }
}
