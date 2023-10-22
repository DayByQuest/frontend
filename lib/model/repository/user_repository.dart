import 'package:flutter_application_1/main.dart';

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

  Future<(List<BadgeClass.Badge>, bool hasNextPage)> getRemoteMyBadge(
      username) async {
    try {
      return _RemoteDataSource.getMyBadge(username);
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

  Future<List<String>> getRemoteInterest() async {
    try {
      return _RemoteDataSource.getInterest();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
