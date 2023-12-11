import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/model/class/interest.dart';
import 'package:image_picker/image_picker.dart';

import '../dataSource/remote_data_source.dart';
import 'package:get_it/get_it.dart';
import './../class/user.dart';
import './../class/badge.dart' as BadgeClass;
import './../class/tracker.dart';

class UserRepository {
  final RemoteDataSource _RemoteDataSource;

  UserRepository({RemoteDataSource? remoteDataSource})
      : _RemoteDataSource = remoteDataSource ?? getIt.get<RemoteDataSource>();

  Future<User> getRemoteMyProfile() async {
    try {
      return await _RemoteDataSource.getMyProfile();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<User> getRemoteUserProfile(String username) async {
    try {
      return await _RemoteDataSource.getUserProfile(username);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Tracker> getRemoteTracker(String username) async {
    try {
      return await _RemoteDataSource.getTracker(username);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<(List<BadgeClass.Badge>, bool hasNextPage, String lastTime)>
      getRemoteMyBadge(String lastTime) async {
    try {
      return await _RemoteDataSource.getMyBadge(lastTime);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<BadgeClass.Badge>> getRemoteBadge(String username) async {
    try {
      return await _RemoteDataSource.getBadge(username);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> patchRemoteBadge(List<int> badgeIdList) async {
    try {
      await _RemoteDataSource.patchBadge(badgeIdList);
      return;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Interest>> getRemoteInterest() async {
    try {
      return await _RemoteDataSource.getInterest();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> patchRemoteInterest(List<String> interest) async {
    try {
      return await _RemoteDataSource.patchInterest(interest);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> getRemoteVisibility() async {
    try {
      return await _RemoteDataSource.getVisibility();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> patchRemoteVisibility(bool isVisibility) async {
    try {
      await _RemoteDataSource.patchVisibility(isVisibility);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> patchRemoteProfileImage(XFile image) async {
    try {
      await _RemoteDataSource.patchProfileImage(image);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<(List<User>, bool hasNextPage, int lastId)> getRemoteFollowingList(
      int lastId, int limit) async {
    try {
      return await _RemoteDataSource.getFollowingList(lastId, limit);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<(List<User>, bool hasNextPage, int lastId)> getRemoteFollowerList(
      int lastId, int limit) async {
    try {
      return await _RemoteDataSource.getFollowerList(lastId, limit);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> deleteRemoteFollower(String username) async {
    try {
      return await _RemoteDataSource.deleteFollower(username);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> postRemoteUserFollow(String username) async {
    try {
      await _RemoteDataSource.postUserFollow(username);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> deleteRemoteUserFollow(String username) async {
    try {
      await _RemoteDataSource.deleteUserfollow(username);
    } catch (e) {
      rethrow;
    }
  }

  Future<(List<User>, bool hasNextPage, int lastId)> getSearchUserList(
    int lastId,
    int limit,
    String keyword,
  ) async {
    try {
      return await _RemoteDataSource.getSearchUserList(lastId, limit, keyword);
    } catch (e) {
      rethrow;
    }
  }
}
