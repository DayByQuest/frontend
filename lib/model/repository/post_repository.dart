import 'package:flutter_application_1/main.dart';

import '../class/post.dart';
import '../dataSource/remote_data_source.dart';

class PostRepository {
  final RemoteDataSource _RemoteDataSource;

  PostRepository({RemoteDataSource? remoteDataSource})
      : _RemoteDataSource = remoteDataSource ?? getIt.get<RemoteDataSource>();

  Future<(List<Post> userPosts, bool hasNextPage)> getRemoteUserPost(
      int limit, int page) async {
    try {
      return _RemoteDataSource.getUserPost(limit, page);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> postRemoteLike(int postId) async {
    try {
      _RemoteDataSource.postLike(postId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteRemoteLike(int postId) async {
    try {
      _RemoteDataSource.deleteLike(postId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> postRemoteDislike(int postId) async {
    try {
      _RemoteDataSource.postDislike(postId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteRemoteDislike(int postId) async {
    try {
      _RemoteDataSource.deleteDislike(postId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> postRemoteSwipe(int postId) async {
    try {
      _RemoteDataSource.postSwipe(postId);
    } catch (e) {
      rethrow;
    }
  }
}
