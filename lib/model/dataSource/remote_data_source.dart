import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import './../class/user.dart';
import './../class/badge.dart' as BadgeClass;
import './../class/tracker.dart';
import './error_handler.dart';

class RemoteDataSource {
  final String? API_BASE_URL;
  final Dio dio;
  final Options options;

  RemoteDataSource()
      : API_BASE_URL = dotenv.env['API_BASE_URL'],
        dio = Dio(),
        options = Options(
          headers: {
            'Authorization': 'UserId 1',
          },
        ) {
    debugPrint('RemoteDataSource API_BASE_URL $API_BASE_URL');
    dio.options.baseUrl = API_BASE_URL!;
  }

  void throwError(DioException e) {
    if (e.response != null) {
      debugPrint('DioException: ${e.response?.data.toString()}');
    } else {
      debugPrint(e.message);
    }
    return;
  }

  Future<User> getMyProfile() async {
    Response response;
    String url = '/profile';
    try {
      debugPrint('getMyProfile:start');
      response = await dio.get(url, options: options);
      debugPrint('getMyProfile: ${response.toString()}');
      //debugPrint(response.data);
      Map<String, dynamic> jsonData = response.data;
      User user = User.fromJson(jsonData);

      return user;
    } on DioException catch (e) {
      throwError(e);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<User> getUserProfile(String username) async {
    Response response;
    String url = '/profile${username}';
    try {
      response = await dio.get(url, options: options);
      debugPrint(response.data);
      Map<String, dynamic> jsonData = response.data;
      User user = User.fromJson(jsonData);
      return user;
    } on DioException catch (e) {
      throwError(e);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<Tracker> getTracker(String username) async {
    Response response;
    String url = '/profile/${'username'}/tracker';
    try {
      response = await dio.get(url, options: options);
      debugPrint(response.data);
      Tracker tracker = Tracker(tracker: response.data.tracker);
      return tracker;
    } on DioException catch (e) {
      throwError(e);
      rethrow;
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
    } on DioException catch (e) {
      throwError(e);
      rethrow;
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
      debugPrint(response.data);
      return response.data == PRIVATE ? true : false;
    } on DioException catch (e) {
      throwError(e);
      rethrow;
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
    } on DioException catch (e) {
      throwError(e);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<(List<BadgeClass.Badge>, bool hasNextPage, int lastId)> getMyBadge(
      int lastId) async {
    Response response;

    String lastIdUrl = '&lastId=$lastId';

    if (lastId == -1) {
      lastIdUrl = '';
    }

    String url = '/badge?limit=10$lastIdUrl';

    try {
      response = await dio.get(url, options: options);
      debugPrint(response.data);
      List<Map<String, dynamic>> jsonDate = response.data.bages;
      bool hasNextPage = 10 <= response.data.length;
      int lastId = response.data.lastId;
      List<BadgeClass.Badge> badges = [];

      for (int i = 0; i < jsonDate.length; i++) {
        Map<String, dynamic> badge = jsonDate[i];
        String name = badge['name'];
        String imageUrl = badge['imageUrl'];
        int id = badge['id'];
        String acquiredAt = badge['acquiredAt'];
        BadgeClass.Badge newBadge = BadgeClass.Badge(
            name: name, imageUrl: imageUrl, id: id, acquiredAt: acquiredAt);
        badges.add(newBadge);
      }

      return (badges, hasNextPage, lastId);
    } on DioException catch (e) {
      throwError(e);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<BadgeClass.Badge>> getBadge(String username) async {
    Response response;
    String url = '/badge/${username}';
    try {
      response = await dio.get(url, options: options);
      debugPrint(response.data);
      List<Map<String, dynamic>> jsonDate = response.data.bages;
      List<BadgeClass.Badge> badges = [];

      for (int i = 0; i < jsonDate.length; i++) {
        Map<String, dynamic> badge = jsonDate[i];
        String name = badge['name'];
        String imageUrl = badge['imageUrl'];
        int id = badge['id'];
        String acquiredAt = badge['acquiredAt'];
        BadgeClass.Badge newBadge = BadgeClass.Badge(
            name: name, imageUrl: imageUrl, id: id, acquiredAt: acquiredAt);
        badges.add(newBadge);
      }

      return badges;
    } on DioException catch (e) {
      throwError(e);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> patchBadge(List<int> badgeIdList) async {
    Response response;
    String url = '/badge';

    try {
      response = await dio.patch(url, data: badgeIdList);
      debugPrint(response.toString());
      return;
    } on DioException catch (e) {
      throwError(e);
      rethrow;
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
      debugPrint(response.data);
      interest.addAll(response.data.interestNames);
      return interest;
    } on DioException catch (e) {
      throwError(e);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> patchInterest(List<String> interest) async {
    Response response;
    String url = '/profile/interest';
    try {
      response = await dio.patch(url, data: interest);
      debugPrint(response.toString());
    } on DioException catch (e) {
      throwError(e);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<(List<User>, bool hasNextPage, int lastId)> getFollowingList(
      int lastId, int limit) async {
    Response response;
    String lastIdUrl = 'lastId=$lastId&';

    if (lastId == -1) {
      lastIdUrl = '';
    }

    String url = '/followings?${lastIdUrl}limit=$limit';
    List<User> followingList = [];

    try {
      response = await dio.get(url, options: options);
      debugPrint(response.data);
      List<Map<String, dynamic>> jsonData = response.data?.users;
      bool hasNextPage = limit < (jsonData.length);
      int nextLastId = response.data?.lastId;

      for (Map<String, dynamic> item in jsonData) {
        User user = User.fromJson(item);
        followingList.add(user);
      }

      return (followingList, hasNextPage, nextLastId);
    } on DioException catch (e) {
      throwError(e);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<(List<User>, bool hasNextPage, int lastId)> getFollowerList(
      int lastId, int limit) async {
    Response response;
    String lastIdUrl = 'lastId=$lastId&';

    if (lastId == -1) {
      lastIdUrl = '';
    }

    String url = '/followers?${lastIdUrl}page=$limit';
    List<User> followerList = [];

    try {
      response = await dio.get(url, options: options);
      debugPrint(response.data);
      List<Map<String, dynamic>> jsonData = response.data?.users;
      bool hasNextPage = limit < (jsonData.length);
      int nextLastId = response.data?.lastId;

      for (Map<String, dynamic> item in jsonData) {
        User user = User.fromJson(item);
        followerList.add(user);
      }

      return (followerList, hasNextPage, nextLastId);
    } on DioException catch (e) {
      throwError(e);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteFollower(String username) async {
    Response response;
    String url = '/profile/${username}/follower';

    try {
      response = await dio.delete(url);
      debugPrint(response.toString());
    } on DioException catch (e) {
      throwError(e);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> postUserFollow(String username) async {
    Response response;
    String url = '/profile/$username/follow';

    try {
      response = await dio.post(url);
      debugPrint(response.toString());
    } on DioException catch (e) {
      throwError(e);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUserfollow(String username) async {
    Response response;
    String url = '/profile/$username/follower';

    try {
      response = await dio.post(url);
      debugPrint(response.toString());
    } on DioException catch (e) {
      throwError(e);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
