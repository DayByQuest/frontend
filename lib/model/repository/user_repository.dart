import 'package:flutter_application_1/main.dart';
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
      return _RemoteDataSource.getMyProfile();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<User> getRemoteUserProfile(String username) async {
    try {
      return _RemoteDataSource.getUserProfile(username);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Tracker> getRemoteTracker(String username) async {
    try {
      return _RemoteDataSource.getTracker(username);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<(List<BadgeClass.Badge>, bool hasNextPage, int lastId)>
      getRemoteMyBadge(int lastId) async {
    try {
      return _RemoteDataSource.getMyBadge(lastId);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<BadgeClass.Badge>> getRemoteBadge(String username) async {
    try {
      return _RemoteDataSource.getBadge(username);
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

  Future<List<String>> getRemoteInterest() async {
    try {
      return _RemoteDataSource.getInterest();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> patchRemoteInterest(List<String> interest) async {
    try {
      return _RemoteDataSource.patchInterest(interest);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> getRemoteVisibility() async {
    try {
      return _RemoteDataSource.getVisibility();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> patchRemoteVisibility(bool isVisibility) async {
    try {
      _RemoteDataSource.patchVisibility(isVisibility);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> patchRemoteProfileImage(XFile image) async {
    try {
      _RemoteDataSource.patchProfileImage(image);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<(List<User>, bool hasNextPage, int lastId)> getRemoteFollowingList(
      int lastId, int limit) async {
    try {
      return _RemoteDataSource.getFollowingList(lastId, limit);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<(List<User>, bool hasNextPage, int lastId)> getRemoteFollowerList(
      int lastId, int limit) async {
    try {
      return _RemoteDataSource.getFollowerList(lastId, limit);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> postRemoteUserFollow(String username) async {
    try {
      _RemoteDataSource.postUserFollow(username);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> deleteRemoteUserFollow(String username) async {
    try {
      _RemoteDataSource.deleteUserfollow(username);
    } catch (e) {
      rethrow;
    }
  }
}
