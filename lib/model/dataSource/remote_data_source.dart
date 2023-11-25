import 'dart:convert';
import 'dart:io';

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/class/comment.dart';
import 'package:flutter_application_1/model/class/failed_post.dart';
import 'package:flutter_application_1/model/class/feed.dart';
import 'package:flutter_application_1/model/class/group.dart';
import 'package:flutter_application_1/model/class/group_post.dart';
import 'package:flutter_application_1/model/class/interest.dart';
import 'package:flutter_application_1/model/class/quest_detail.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_plus/image_picker_plus.dart';
import 'package:http_parser/http_parser.dart';

import '../class/post.dart';
import './../class/user.dart';
import './../class/badge.dart' as BadgeClass;
import './../class/tracker.dart';
import './error_handler.dart';

class RemoteDataSource {
  final String? API_BASE_URL;
  final Dio dio;
  final Options options;
  static String USER_NAME = dotenv.env['USER_NAME'] ?? '';

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

  String throwError(DioException e) {
    if (e.response != null) {
      debugPrint('DioException: ${e.response?.data.toString()}');
    } else {
      debugPrint(e.message);
    }
    return e.response?.data.message;
  }

  Future<User> getMyProfile() async {
    Response response;
    String url = '/profile';
    try {
      //debugPrint('getMyProfile:start');
      response = await dio.get(url, options: options);
      //debugPrint('getMyProfile: ${response.toString()}');
      Map<String, dynamic> jsonData = response.data;
      User user = User.fromJson(jsonData);
      //debugPrint('getMyProfile:end');
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
    String url = '/profile/${username}';
    try {
      response = await dio.get(url, options: options);
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
    String url = '/profile/${username}/tracker';
    try {
      //debugPrint('getTracker:start');
      response = await dio.get(url, options: options);
      Map<String, dynamic> jsonData = response.data;
      Tracker tracker = Tracker.fromJson(jsonData);
      //debugPrint('getTracker:end');
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
      response = await dio.patch(
        url,
        data: formData,
        options: options,
      );
      debugPrint('patchProfileImage response: ${response.toString()}');
      return;
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
      debugPrint(response.toString());
      Map<String, dynamic> json = response.data;
      return json['visibility'] == PRIVATE ? true : false;
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
    final jsonData = jsonEncode(data);
    try {
      response = await dio.patch(
        url,
        data: jsonData,
        options: options,
      );
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
      //debugPrint('getBadge:start $username');
      response = await dio.get(url, options: options);
      Map<String, dynamic> jsonDate = response.data;
      //debugPrint('getBadge:jsonDate ${jsonDate.toString()}');
      List<dynamic> badgeJson = jsonDate['badges'];
      List<BadgeClass.Badge> badges =
          badgeJson.map((badge) => BadgeClass.Badge.fromJson(badge)).toList();
      //debugPrint('getBadge:end');
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
      response = await dio.patch(
        url,
        data: badgeIdList,
        options: options,
      );
      debugPrint(response.toString());
      return;
    } on DioException catch (e) {
      throwError(e);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Interest>> getInterest() async {
    Response response;
    String url = '/interest';

    try {
      debugPrint('getInterest start');
      response = await dio.get(
        url,
        options: options,
      );
      Map<String, dynamic> jsonData = response.data;
      List<Interest> interests = (jsonData['interests'] as List)
          .map((interestJson) => Interest.fromJson(interestJson))
          .toList();
      debugPrint('getInterest end');
      return interests;
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
      debugPrint('patchInterest start');
      Map<String, dynamic> data = {
        "interests": interest,
      };
      final jsonData = jsonEncode(data);
      response = await dio.patch(
        url,
        data: jsonData,
        options: options,
      );
      debugPrint('patchInterest end: ${response.toString()}');
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

    try {
      response = await dio.get(
        url,
        options: options,
      );
      debugPrint('getFollowingList start');
      Map<String, dynamic> jsonData = response.data;
      debugPrint('getFollowingList ${jsonData.toString()}');
      List<dynamic> usersJson = jsonData['users'];
      List<User> followingList =
          usersJson.map((userJson) => User.fromJson(userJson)).toList();
      bool hasNextPage = limit <= (usersJson.length);
      int nextLastId = jsonData['lastId'];
      debugPrint('getFollowingList end');
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

    String url = '/followers?${lastIdUrl}limit=$limit';

    try {
      debugPrint("getFollowerList start: $url");
      response = await dio.get(
        url,
        options: options,
      );
      Map<String, dynamic> jsonData = response.data;
      List<dynamic> usersJson = jsonData['users'];
      bool hasNextPage = limit <= (usersJson.length);
      int nextLastId = jsonData['lastId'];
      List<User> followerList =
          usersJson.map((userJson) => User.fromJson(userJson)).toList();

      debugPrint("getFollowerList end");
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
      response = await dio.delete(
        url,
        options: options,
      );
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
      response = await dio.post(
        url,
        options: options,
      );
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
    String url = '/profile/$username/follow';

    try {
      response = await dio.delete(
        url,
        options: options,
      );
      debugPrint(response.toString());
    } on DioException catch (e) {
      throwError(e);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<(List<Post> userPosts, bool hasNextPage, int lastId)> getUserPost(
      int limit, int lastId) async {
    String lastIdUrl = '&lastId=$lastId';

    if (lastId == -1) {
      lastIdUrl = '';
    }

    Response response;
    String url = '/profile/${USER_NAME}/post?limit=$limit$lastIdUrl';

    ///profile/{username}/post?limit=5&lastid=2

    try {
      debugPrint('getUserPost start $url');

      response = await dio.get(url, options: options);
      Map<String, dynamic> jsonData = response.data;
      List<dynamic> postsJson = jsonData['posts'];

      Post data = Post.fromJson(postsJson[0]);
      //debugPrint('getUserPost data ${data.postImages.postImageList[0]}');

      List<Post> userPosts =
          postsJson.map((postJson) => Post.fromJson(postJson)).toList();
      debugPrint('getUserPost userPosts ${userPosts}');

      bool hasNextPage = limit <= userPosts.length;
      int lastId = jsonData['lastId'];

      debugPrint('getUserPost end');
      return (userPosts, hasNextPage, lastId);
    } on DioException catch (e) {
      throwError(e);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> postLike(int postId) async {
    Response response;
    String url = '/post/$postId/like';

    try {
      response = await dio.post(
        url,
        options: options,
      );
      debugPrint(response.toString());
    } on DioException catch (e) {
      throwError(e);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteLike(int postId) async {
    Response response;
    String url = '/post/$postId/like';

    try {
      response = await dio.delete(
        url,
        options: options,
      );
      debugPrint(response.toString());
    } on DioException catch (e) {
      throwError(e);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> postDislike(int postId) async {
    Response response;
    String url = '/post/$postId/dislike';

    try {
      response = await dio.post(
        url,
        options: options,
      );
      debugPrint(response.toString());
    } on DioException catch (e) {
      throwError(e);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteDislike(int postId) async {
    Response response;
    String url = '/post/$postId/like';

    try {
      response = await dio.delete(
        url,
        options: options,
      );
      debugPrint(response.toString());
    } on DioException catch (e) {
      throwError(e);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> postSwipe(int postId) async {
    Response response;
    String url = '/post/$postId/swipe';

    try {
      response = await dio.post(
        url,
        options: options,
      );
      debugPrint(response.toString());
    } on DioException catch (e) {
      throwError(e);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<(List<Post>, bool hasNextPage, int lastId)> getFeed(
      int limit, int lastId) async {
    String lastIdUrl = '&lastId=$lastId';

    if (lastId == -1) {
      lastIdUrl = '';
    }

    Response response;
    String url = '/feed?limit=5$lastIdUrl';

    try {
      debugPrint('getFeed start: $url');
      response = await dio.get(url, options: options);
      Map<String, dynamic> jsonData = response.data;
      debugPrint('getFeed jsonData: ${jsonData.toString()}');
      List<dynamic> postsJson = jsonData['posts'];
      List<Post> posts =
          postsJson.map((postJson) => Post.fromJson(postJson)).toList();
      bool hasNextPage = limit <= posts.length;
      int lastId = jsonData['lastId'];
      debugPrint('getFeed end');
      return (posts, hasNextPage, lastId);
    } on DioException catch (e) {
      throwError(e);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<GroupPost>> getGroupFeed() async {
    Response response;
    String url = '/group/recommendation';

    try {
      response = await dio.get(url, options: options);
      Map<String, dynamic> jsonData = response.data;
      List<dynamic> groupsJson = jsonData['groups'];
      debugPrint('getGroupFeed groupsJson: ${groupsJson.toString()}');
      List<GroupPost> groupPosts =
          groupsJson.map((groupJson) => GroupPost.fromJson(groupJson)).toList();

      return groupPosts;
    } on DioException catch (e) {
      throwError(e);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> postGroupDislike(int groupId) async {
    Response response;
    String url = '/group/$groupId/dislike';

    try {
      debugPrint('postGroupDislike start: $url');
      response = await dio.post(url, options: options);
      debugPrint(response.toString());
    } on DioException catch (e) {
      throwError(e);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteGroupDislike(int groupId) async {
    Response response;
    String url = '/group/$groupId/dislike';

    try {
      response = await dio.delete(url, options: options);
      debugPrint(response.toString());
    } on DioException catch (e) {
      throwError(e);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> postGroupJoin(int groupId) async {
    Response response;
    String url = '/group/$groupId/user';

    try {
      response = await dio.post(url, options: options);
      debugPrint(response.toString());
    } on DioException catch (e) {
      throwError(e);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteGroupJoin(int groupId) async {
    Response response;
    String url = '/group/$groupId/user';

    try {
      response = await dio.delete(url, options: options);
      debugPrint(response.toString());
    } on DioException catch (e) {
      throwError(e);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<Post> getDetailPost(int postId) async {
    Response response;
    String url = '/post/$postId';
    try {
      response = await dio.get(url, options: options);
      Map<String, dynamic> jsonData = response.data;
      debugPrint('jsonData: $jsonData');
      Post detailPost = Post.fromJson(jsonData);
      return detailPost;
    } on DioException catch (e) {
      throwError(e);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<(List<Comment>, bool hasNextPage, int lastId)> getComment(
      int postId, int limit, int lastId) async {
    String lastIdUrl = '&lastId=$lastId';

    if (lastId == -1) {
      lastIdUrl = '';
    }

    Response response;
    String url = '/comment/$postId?limit=$limit$lastIdUrl';

    try {
      response = await dio.get(url, options: options);
      Map<String, dynamic> jsonData = response.data;
      List<dynamic> commentsJson = jsonData['comments'];
      List<Comment> comments = commentsJson
          .map((commentJson) => Comment.fromJson(commentJson))
          .toList();
      bool hasNextPage = limit <= comments.length;
      int lastId = jsonData['lastId'];

      return (comments, hasNextPage, lastId);
    } on DioException catch (e) {
      throwError(e);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> postComment(int postId, String comment) async {
    Response response;
    String url = '/comment/$postId';

    try {
      response = await dio.post(
        url,
        options: options,
        data: {'content': comment},
      );
      debugPrint(response.toString());
    } on DioException catch (e) {
      throwError(e);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<QuestDetail>> getQuest(state) async {
    Response response;
    String url = '/quest?state=$state';

    try {
      debugPrint('getQuest start');
      response = await dio.get(
        url,
        options: options,
      );
      Map<String, dynamic> jsonData = response.data;
      List<dynamic> questJson = jsonData['quests'];
      debugPrint('questJson $questJson');
      List<QuestDetail> questList =
          questJson.map((quest) => QuestDetail.fromJson(quest)).toList();

      debugPrint('getQuest end');
      return questList;
    } on DioException catch (e) {
      throwError(e);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> postCreatePost(List<SelectedByte> selectedByte, String content,
      {int? questId}) async {
    Response response;
    String url = '/post';

    FormData formData = FormData();

    // JSON 데이터 추가
    Map<String, dynamic> jsonData = questId != null
        ? {"content": "${content}", "questId": "$questId"}
        : {"content": "${content}"};
    final jsonBody = jsonEncode(jsonData);
    final EncodeJsonData = MultipartFile.fromString(
      jsonBody,
      contentType: MediaType.parse('application/json'),
    );

    formData.files.add(MapEntry(
      'request',
      EncodeJsonData,
    ));

    for (int i = 0; i < selectedByte.length; i++) {
      // 이미지 파일 추가
      formData.files.add(MapEntry(
        "images",
        await MultipartFile.fromFile(
          selectedByte[i].selectedFile.absolute.path,
        ),
      ));
    }

    try {
      response = await dio.post(
        url,
        data: formData,
        options: options,
      );
      debugPrint('postCreatePost 성공: ${response.toString()}');
    } on DioException catch (e) {
      debugPrint('DioException: ${e.response}');
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> createGroupQuest(
      List<SelectedByte> selectedByte, String description, int groupId) async {
    Response response;
    String url = '/group/quest';

    FormData formData = FormData();

    // JSON 데이터 추가
    Map<String, dynamic> jsonData = {
      "imageDescription": "$description",
      "groupId": "$groupId"
    };
    final jsonBody = jsonEncode(jsonData);
    final encodeJsonData = MultipartFile.fromString(
      jsonBody,
      contentType: MediaType.parse('application/json'),
    );
    formData.files.add(MapEntry(
      'request',
      encodeJsonData,
    ));

    for (int i = 0; i < selectedByte.length; i++) {
      // 이미지 파일 추가
      formData.files.add(MapEntry(
        "images",
        await MultipartFile.fromFile(
          selectedByte[i].selectedFile.absolute.path,
        ),
      ));
    }

    try {
      response = await dio.post(
        url,
        data: formData,
        options: options,
      );
      Map<String, dynamic> responseData = response.data;
      int questId = responseData["questId"];
      debugPrint('createGroupQuest 성공: ${questId}');
      return questId;
    } on DioException catch (e) {
      throwError(e);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createGroupQuestDetail(String title, String content,
      String expiredAt, String interest, String label, int questId) async {
    Response response;
    String url = '/group/$questId/quest/detail';

    Map<String, dynamic> jsonData = {
      "title": title,
      "content": content,
      "expiredAt": expiredAt,
      "interest": interest,
      "label": label,
      "questId": questId,
    };

    String encodeJsonData = jsonEncode(jsonData);

    try {
      response = await dio.post(
        url,
        options: options,
        data: encodeJsonData,
      );

      debugPrint('createGroupQuestDetail 성공: ${response}');
      return;
    } on DioException catch (e) {
      throwError(e);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Group>> getMyGroupList() async {
    Response response;
    String url = '/group';

    try {
      debugPrint('getMyGroupList start');
      response = await dio.get(
        url,
        options: options,
      );
      Map<String, dynamic> jsonData = response.data;
      List<dynamic> groupsJson = jsonData['groups'];
      List<Group> groupList =
          groupsJson.map((groupJson) => Group.fromJson(groupJson)).toList();
      debugPrint('getMyGroupList end');
      return groupList;
    } on DioException catch (e) {
      throwError(e);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<Group> getGroupProfile(int groupId) async {
    Response response;
    String url = '/group/$groupId';

    try {
      debugPrint('getGroupProfile start');
      response = await dio.get(
        url,
        options: options,
      );
      Map<String, dynamic> jsonData = response.data;
      Group targetGroup = Group.fromJson(jsonData);
      debugPrint('getGroupProfile end');
      return targetGroup;
    } on DioException catch (e) {
      throwError(e);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<QuestDetail>> getGroupQuestList(int groupId) async {
    Response response;
    String url = '/group/$groupId/quest';

    try {
      debugPrint('getGroupQuestList start');
      response = await dio.get(
        url,
        options: options,
      );
      Map<String, dynamic> jsonData = response.data;
      List<dynamic> questsJson = jsonData['quests'];
      List<QuestDetail> questList = questsJson
          .map((questJson) => QuestDetail.fromJson(questJson))
          .toList();
      debugPrint('getGroupQuestList end');
      return questList;
    } on DioException catch (e) {
      throwError(e);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> postQuestAccept(int questId) async {
    Response response;
    String url = '/quest/$questId/accept';

    try {
      response = await dio.post(
        url,
        options: options,
      );
      debugPrint('postQuestAccept 성공: ${response}');
      return;
    } on DioException catch (e) {
      throwError(e);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteQuestAccept(int questId) async {
    Response response;
    String url = '/quest/$questId/accept';

    try {
      response = await dio.delete(
        url,
        options: options,
      );
      debugPrint('deleteQuestAccept 성공: ${response}');
      return;
    } on DioException catch (e) {
      throwError(e);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> joinGroup(int groupId) async {
    Response response;
    String url = '/group/$groupId/user';

    try {
      response = await dio.post(
        url,
        options: options,
      );
      debugPrint('joinGroup 성공: ${response}');
      return;
    } on DioException catch (e) {
      throwError(e);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> quitGroup(int groupId) async {
    Response response;
    String url = '/group/$groupId/user';

    try {
      response = await dio.delete(
        url,
        options: options,
      );
      debugPrint('quitGroup 성공: ${response}');
      return;
    } on DioException catch (e) {
      throwError(e);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<(List<Post>, bool hasNextPage, int lastId)> getGroupPost(
      int limit, int lastId, int groupId) async {
    String lastIdUrl = '&lastId=$lastId';

    if (lastId == -1) {
      lastIdUrl = '';
    }

    Response response;
    String url = '/group/$groupId/post?limit=$limit$lastIdUrl';

    try {
      debugPrint('getGroupPost start: $url');
      response = await dio.get(url, options: options);
      Map<String, dynamic> jsonData = response.data;
      debugPrint('getGroupPost jsonData: ${jsonData.toString()}');
      List<dynamic> postsJson = jsonData['posts'];
      List<Post> posts =
          postsJson.map((postJson) => Post.fromJson(postJson)).toList();
      bool hasNextPage = limit <= posts.length;
      int lastId = jsonData['lastId'];
      debugPrint('getGroupPost end');
      return (posts, hasNextPage, lastId);
    } on DioException catch (e) {
      throwError(e);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<(List<User>, bool hasNextPage, int lastId)> getGroupMemberList(
      int limit, int lastId, int groupId) async {
    String lastIdUrl = '&lastId=$lastId';

    if (lastId == -1) {
      lastIdUrl = '';
    }

    Response response;
    String url = '/group/$groupId/user?limit=5$lastIdUrl';

    try {
      debugPrint('getGroupMemberList start: $url');
      response = await dio.get(url, options: options);
      Map<String, dynamic> jsonData = response.data;
      debugPrint('getGroupMemberList jsonData: ${jsonData.toString()}');
      List<dynamic> usersJson = jsonData['users'];
      List<User> users =
          usersJson.map((userJson) => User.fromJson(userJson)).toList();
      bool hasNextPage = limit <= users.length;
      int lastId = jsonData['lastId'];
      debugPrint('getGroupMemberList end');
      return (users, hasNextPage, lastId);
    } on DioException catch (e) {
      throwError(e);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<(List<FailedPost>, bool hasNextPage)> getFailedGroupQuestList(
      int questId) async {
    Response response;
    String url = '/group/$questId/quest/failed';

    try {
      debugPrint('getFailedGroupQuestList start: $url');

      response = await dio.get(url, options: options);
      Map<String, dynamic> jsonData = response.data;
      debugPrint('getFailedGroupQuestList jsonData: ${jsonData.toString()}');
      List<dynamic> postsJson = jsonData['posts'];
      List<FailedPost> posts =
          postsJson.map((postJson) => FailedPost.fromJson(postJson)).toList();
      bool hasNextPage = 10 <= posts.length;
      debugPrint('getFailedGroupQuestList end');
      return (posts, hasNextPage);
    } on DioException catch (e) {
      throwError(e);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> postPostJudgment(int postId, bool approval) async {
    Response response;
    String url = '/group/$postId/post';

    Map<String, dynamic> jsonData = {
      "approval": approval,
    };

    String encodeJsonData = jsonEncode(jsonData);

    try {
      response = await dio.patch(
        url,
        options: options,
        data: encodeJsonData,
      );

      debugPrint('postPostJudgment 성공: ${response}');
      return;
    } on DioException catch (e) {
      throwError(e);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
