import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import './../class/user.dart';
import './../class/badge.dart' as BadgeClass;
import './../class/tracker.dart';
import './error_handler.dart';

class RemoteDataSource {
  Options options = Options(
    headers: {
      'Authorization': 'UserId 1',
    },
  );
  final dio = Dio();

  void throwError(Response response) {
    if (response.statusCode != 200) {
      throw Exception(statusErrorHandler(response));
    }
    if (response.data.code) {
      throw Exception(commonErrorHandler(response));
    }
    return;
  }

  Future<User> getMyProfile() async {
    Response response;
    String url = '/profile';
    try {
      response = await dio.get(url, options: options);
      if (response.statusCode != 200) {
        throw Exception(statusErrorHandler(response));
      }
      if (response.data.code) {
        throw Exception(commonErrorHandler(response));
      }
      debugPrint(response.data);
      Map<String, dynamic> jsonData = response.data;
      User user = User.fromJson(jsonData);
      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<User> getUserProfile(String username) async {
    Response response;
    String url = '/profile${username}';
    try {
      response = await dio.get(url, options: options);
      if (response.statusCode != 200) {
        throw Exception(statusErrorHandler(response));
      }
      if (response.data.code) {
        throw Exception(commonErrorHandler(response));
      }
      debugPrint(response.data);
      Map<String, dynamic> jsonData = response.data;
      User user = User.fromJson(jsonData);
      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<Tracker> getTracker(String username) async {
    Response response;
    String url = '/profile/${username}/tracker';
    try {
      response = await dio.get(url, options: options);
      if (response.statusCode != 200) {
        throw Exception(statusErrorHandler(response));
      }
      if (response.data.code) {
        throw Exception(commonErrorHandler(response));
      }
      debugPrint(response.data);
      Tracker tracker = Tracker(tracker: response.data.tracker);
      return tracker;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> patchProfileImage(XFile image) async {
    Response response;
    String url = '/profile/image';
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(image.path),
    });
    try {
      response = await dio.patch(url, data: formData);
      throwError(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> getVisibility() async {
    Response response;
    String url = '/profile/visibility';
    const String PRIVATE = 'PRIVATE';
    const String PUBLIC = 'PUBLIC';

    try {
      response = await dio.get(url, options: options);
      throwError(response);
      debugPrint(response.data);
      return response.data == PRIVATE ? true : false;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> patchVisibility(bool isVisibility) async {
    Response response;
    String url = '/profile/visibility';
    Map<String, dynamic> data = {
      "visibility": (isVisibility ? "PRIVATE" : "PUBLIC")
    };
    try {
      response = await dio.patch(url, data: data);
      if (response.statusCode != 200) {
        throw Exception(statusErrorHandler(response));
      }
      if (response.data.code) {
        throw Exception(commonErrorHandler(response));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<(List<BadgeClass.Badge>, bool hasNextPage)> getMyBadge(
      int page) async {
    Response response;
    String url = '/badge?limit=10&page=${page}';
    try {
      response = await dio.get(url, options: options);
      if (response.statusCode != 200) {
        throw Exception(statusErrorHandler(response));
      }
      if (response.data.code) {
        throw Exception(commonErrorHandler(response));
      }
      debugPrint(response.data);
      List<Map<String, dynamic>> jsonDate = response.data.bages;
      List<BadgeClass.Badge> badges = [];
      for (int i = 0; i < jsonDate.length; i++) {
        Map<String, dynamic> badge = jsonDate[i];
        String name = badge['name'];
        String imageUrl = badge['imageUrl'];
        String id = badge['id'];
        String acquiredAt = badge['acquiredAt'];
        BadgeClass.Badge newBadge = BadgeClass.Badge(
            name: name, imageUrl: imageUrl, id: id, acquiredAt: acquiredAt);
        badges.add(newBadge);
      }
      bool hasNextPage = response.data.hasNextPage;
      return (badges, hasNextPage);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<BadgeClass.Badge>> getBadge(String username) async {
    Response response;
    String url = '/badge/${username}';
    try {
      response = await dio.get(url, options: options);
      if (response.statusCode != 200) {
        throw Exception(statusErrorHandler(response));
      }
      if (response.data.code) {
        throw Exception(commonErrorHandler(response));
      }
      debugPrint(response.data);
      List<Map<String, dynamic>> jsonDate = response.data.bages;
      List<BadgeClass.Badge> badges = [];
      for (int i = 0; i < jsonDate.length; i++) {
        Map<String, dynamic> badge = jsonDate[i];
        String name = badge['name'];
        String imageUrl = badge['imageUrl'];
        String id = badge['id'];
        String acquiredAt = badge['acquiredAt'];
        BadgeClass.Badge newBadge = BadgeClass.Badge(
            name: name, imageUrl: imageUrl, id: id, acquiredAt: acquiredAt);
        badges.add(newBadge);
      }

      return badges;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<String>> getInterest() async {
    Response response;
    String url = '/interest';
    List<String> interest = [];
    try {
      response = await dio.get(url, options: options);
      throwError(response);
      debugPrint(response.data);
      interest.addAll(response.data.interestNames);
      return interest;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> patchInterest(List<String> interest) async {
    Response response;
    String url = '/profile/interest';
    try {
      response = await dio.patch(url, data: interest);
      throwError(response);
      debugPrint(response.toString());
    } catch (e) {
      rethrow;
    }
  }
}
