import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/class/comment.dart';
import 'package:flutter_application_1/model/class/group_post.dart';
import 'package:flutter_application_1/model/class/interest.dart';
import 'package:flutter_application_1/model/class/quest_detail.dart';
import 'package:image_picker/image_picker.dart';

import '../class/post.dart';
import './remote_data_source.dart';
import 'package:mockito/mockito.dart';
import './../class/user.dart';
import './../class/badge.dart' as BadgeClass;
import './../class/tracker.dart';

class MockDataSource extends Mock implements RemoteDataSource {
  String IMAGE_IDENTIFIER = 'base.png';
  String IMAGE_URL = 'https://picsum.photos/200/300';

  @override
  Future<User> getMyProfile() async {
    String username = "abcdefghijklmno";
    String name = "김김승승태태";
    String imageUrl = IMAGE_URL;
    int followingCount = 999;
    int followerCount = 0;
    int postCount = 0;
    bool blocking = false;
    User user = User(
        username: username,
        name: name,
        imageUrl: imageUrl,
        followingCount: followingCount,
        followerCount: followerCount,
        postCount: postCount,
        blocking: blocking);

    return Future.delayed(Duration(seconds: 1), () {
      return user;
    });
  }

  @override
  Future<User> getUserProfile(String username) async {
    String username = "abcdefghijklmno";
    String name = "김김승승태태";
    String imageUrl = IMAGE_URL;
    int followingCount = 999;
    int followerCount = 0;
    int postCount = 0;
    bool blocking = false;
    bool follwing = true;
    User user = User(
      username: username,
      name: name,
      imageUrl: imageUrl,
      followingCount: followingCount,
      followerCount: followerCount,
      postCount: postCount,
      blocking: blocking,
      following: follwing,
    );

    return Future.delayed(Duration(seconds: 1), () {
      return user;
    });
  }

  @override
  Future<Tracker> getTracker(String username) async {
    List<int> tracker = [];
    for (int i = 0; i < 60; i++) {
      tracker.add(Random().nextInt(10));
    }
    return Future.delayed(Duration(seconds: 1), () {
      return Tracker(tracker: tracker);
    });
  }

  @override
  Future<(List<BadgeClass.Badge>, bool hasNextPage, int lastId)> getMyBadge(
      int lastId) async {
    String name = "김김승승태태";
    String imageUrl = IMAGE_URL;
    String id = "aaaa";
    String acquiredAt = "2000/00/00";

    List<BadgeClass.Badge> badges = [];
    for (int i = 0; i < 10; i++) {
      BadgeClass.Badge newBadge = BadgeClass.Badge(
          name: name, imageUrl: imageUrl, id: i, acquiredAt: acquiredAt);
      badges.add(newBadge);
    }
    return (badges, true, lastId + 1);
  }

  @override
  Future<List<BadgeClass.Badge>> getBadge(String username) async {
    String name = "김김승승태태";
    String imageUrl = IMAGE_URL;
    String id = "aaaa";
    String acquiredAt = "2000/00/00";

    List<BadgeClass.Badge> badges = [];
    for (int i = 0; i < 10; i++) {
      BadgeClass.Badge newBadge = BadgeClass.Badge(
          name: name, imageUrl: imageUrl, id: i, acquiredAt: acquiredAt);
      badges.add(newBadge);
    }

    return Future.delayed(Duration(seconds: 1), () {
      return badges;
    });
  }

  @override
  Future<void> patchBadge(List<int> badgeIdList) async {
    try {
      debugPrint('patchBadge: badgeIdList - ${badgeIdList.toString()}');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> patchInterest(List<String> interest) async {
    debugPrint("관심사 잘 넘어왔는지 확인!");
    debugPrint(interest.toString());
    return Future.delayed(Duration(seconds: 1), () {
      return;
    });
  }

  @override
  Future<bool> getVisibility() async {
    return false;
  }

  @override
  Future<void> patchVisibility(bool isVisibility) async {
    debugPrint('비공개 설정! ${isVisibility.toString()}');
  }

  @override
  Future<void> patchProfileImage(XFile image) async {
    debugPrint('image 잘 건네짐');
    debugPrint(image.toString());
    return;
  }

  @override
  Future<(List<User>, bool hasNextPage, int lastId)> getFollowingList(
      int lastId, int limit) async {
    List<User> followingList = [];
    bool hasNextPage = true;
    debugPrint("mockData getFollowingList followingList lastId: $lastId");

    String username = "abcdefghijklmnoadwqz";
    String name = "김김승승태태";
    String imageUrl = IMAGE_URL;
    bool following = 50 < Random.secure().nextInt(100);

    for (int i = 0; i < 10; i++) {
      User user = User(
        imageUrl: imageUrl,
        name: name,
        username: username,
        following: following,
      );
      followingList.add(user);
    }

    return (followingList, hasNextPage, lastId + 1);
  }

  @override
  Future<(List<User>, bool hasNextPage, int lastId)> getFollowerList(
      int lastId, int limit) async {
    List<User> followerList = [];
    bool hasNextPage = true;
    debugPrint("mockData getFollowerList 팔로워 리스트 라스트 아이디값: $lastId");

    String username = "abcdefghijklmnoadwqz";
    String name = "김김승승태태";
    String imageUrl = IMAGE_URL;
    bool following = 50 < Random.secure().nextInt(100);

    for (int i = 0; i < 10; i++) {
      User user = User(
        imageUrl: imageUrl,
        name: name,
        username: username,
        following: following,
      );
      followerList.add(user);
    }

    return (followerList, hasNextPage, lastId + 1);
  }

  @override
  Future<void> deleteFollower(String username) async {
    try {
      debugPrint('deleteFollower: $username 잘 전송됨.');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> postUserFollow(String username) async {
    debugPrint('postUserFollow: $username 잘 전송됨, 팔로우 완료!');
  }

  @override
  Future<void> deleteUserfollow(String username) async {
    debugPrint('deleteUserfollow: $username 잘 전송됨, 언팔로우 완료!');
  }

  @override
  Future<(List<Post> userPosts, bool hasNextPage, int lastId)> getUserPost(
      int limit, int page) async {
    try {
      final mockData = {
        "posts": List.generate(5, (index) {
          return {
            "author": {
              "username": "username",
              "name": "한글이름",
              "imageIdentifier": IMAGE_IDENTIFIER,
              "postCount": 0,
              "following": false,
              "blocking": false,
            },
            "id": index + 1,
            "content": "글 내용입니다",
            "updatedAt": "날짜",
            "liked": false,
            "images": [
              {
                "imageIdentifier": IMAGE_IDENTIFIER,
              },
              {
                "imageIdentifier": IMAGE_IDENTIFIER,
              },
            ],
          };
        }),
        "hasNextPage": true,
      };
      final jsonStr = json.encode(mockData);
      dynamic response = {'data': jsonStr};

      //debugPrint('response $response');
      Map<String, dynamic> jsonData = json.decode(response['data']);
      List<dynamic> postsJson = jsonData['posts'];
      //debugPrint('postsJson[0] ${postsJson[0]}');
      List<Post> userPosts =
          postsJson.map((postJson) => Post.fromJson(postJson)).toList();

      bool hasNextPage = jsonData['hasNextPage'];
      //debugPrint("getUserPost: 값 반환!");
      return (userPosts, hasNextPage, 0);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> postLike(int postId) async {
    try {
      debugPrint('postLike $postId 전송!');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteLike(int postId) async {
    try {
      debugPrint('deleteLike $postId 전송!');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> postDislike(int postId) async {
    try {
      debugPrint('postDislike $postId 전송!');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteDislike(int postId) async {
    try {
      debugPrint('deleteDislike $postId 전송!');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> postSwipe(int postId) async {
    try {
      debugPrint('postSwipe $postId 전송!');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<(List<Post>, bool hasNextPage, int lastId)> getFeed(
      int limit, int lastId) async {
    try {
      String response = '''
{
  "posts": [
    {
      "author": {
        "username": "username",
        "name": "한글이름",
        "imageIdentifier": "${IMAGE_IDENTIFIER}",
        "postCount": 0,
        "following": false,
        "blocking": false
      },
      "id": 1,
      "content": "글 내용입니다",
      "updatedAt": "날짜",
      "liked": true,
      "imageIdentifiers": [
        "${IMAGE_IDENTIFIER}",
        "${IMAGE_IDENTIFIER}",
        "${IMAGE_IDENTIFIER}"
      ]
    }
  ],
  "lastId": 6
}
''';
      Map<String, dynamic> jsonMap = json.decode(response);
      List<dynamic> postsJson = jsonMap['posts'];
      debugPrint('postsJson: ${postsJson}');
      List<Post> posts =
          postsJson.map((postJson) => Post.fromJson(postJson)).toList();

      bool hasNextPage = limit <= posts.length;
      int lastId = jsonMap['lastId'];

      debugPrint('getFeed: 동작');

      return (posts, true, lastId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<GroupPost>> getGroupPost() async {
    String jsonData = '''
    {
      "groups": [
        {
          "groupId": 1,
          "name": "그룹이름",
          "description": "설명",
          "imageIdentifier": "${IMAGE_IDENTIFIER}",
          "userCount": 5
        }
      ]
    }
  ''';

    try {
      debugPrint('getGroupPost: 시작');
      Map<String, dynamic> jsonMap = json.decode(jsonData);
      List<dynamic> groupsJson = jsonMap['groups'];
      List<GroupPost> groupPosts =
          groupsJson.map((groupJson) => GroupPost.fromJson(groupJson)).toList();

      debugPrint('getGroupPost: 동작');
      return groupPosts;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> postGroupDislike(int groupId) async {
    try {
      debugPrint('groupDislike: $groupId');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteGroupDislike(int groupId) async {
    try {
      debugPrint('deleteGroupDislike: $groupId');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> postGroupJoin(int groupId) async {
    try {
      debugPrint('postGroupJoin: $groupId');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteGroupJoin(int groupId) async {
    try {
      debugPrint('deleteGroupJoin: $groupId');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Post> getDetailPost(int postId) async {
    try {
      Map<String, dynamic> jsonData = {
        "author": {
          "username": "mockUsername",
          "name": "모크이름",
          "imageIdentifier": "$IMAGE_IDENTIFIER",
          "postCount": 0,
          "following": false,
          "blocking": false
        },
        "id": 1,
        "content": "모크 내용입니다",
        "updatedAt": "모크날짜",
        "liked": false,
        "imageIdentifiers": [
          "${IMAGE_IDENTIFIER}",
          "${IMAGE_IDENTIFIER}",
          "${IMAGE_IDENTIFIER}"
        ],
        "quest": {"id": 1, "title": "모크 퀘스트 이름", "state": "성공"}
      };

      Post detailPost = Post.fromJson(jsonData);
      return detailPost;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<(List<Comment>, bool hasNextPage, int lastId)> getComment(
      int postId, int limit, int lastId) async {
    try {
      Map<String, dynamic> jsonData = {
        "comments": [
          {
            "author": {
              "username": "username",
              "name": "한글이름",
              "imageIdentifier": "$IMAGE_IDENTIFIER",
              "postCount": 0,
              "following": false,
              "blocking": false
            },
            "id": 1,
            "content": "댓글 내용",
          },
          {
            "author": {
              "username": "username",
              "name": "한글이름",
              "imageIdentifier": "$IMAGE_IDENTIFIER",
              "postCount": 0,
              "following": false,
              "blocking": false
            },
            "id": 1,
            "content": "댓글 내용",
          },
        ],
        "lastId": 5
      };
      List<dynamic> commentsJson = jsonData['comments'];
      List<Comment> comments = commentsJson
          .map((commentJson) => Comment.fromJson(commentJson))
          .toList();
      bool hasNextPage = limit <= comments.length;
      int lastId = jsonData['lastId'];

      return (comments, true, lastId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> postComment(int postId, String comment) async {
    try {
      debugPrint('postComment: $comment');
    } catch (e) {
      rethrow;
    }
  }

  Future<List<QuestDetail>> getQuest(state) async {
    try {
      Map<String, dynamic> jsonData = {
        "quests": [
          {
            "id": 1,
            "category": "NORMAL",
            "title": "퀘스트 제목",
            "content": "퀘스트 내용",
            "expiredAt": "...",
            "interest": "FOOD",
            "imageIdentifier": "$IMAGE_IDENTIFIER",
            "state": "DOING",
            "rewardCount": 30, // 보상을 받기 위한 수행 횟수
            "currentCount": 50, // 내가 수행한 횟수
            "groupName": "그룹이름" // 그룹 아니면 null
          },
          {
            "id": 2,
            "category": "NORMAL",
            "title": "퀘스트 제목2",
            "content": "퀘스트 내용2",
            "expiredAt": "...",
            "interest": "FOOD",
            "imageIdentifier": "$IMAGE_IDENTIFIER",
            "state": "DOING",
            "rewardCount": 30, // 보상을 받기 위한 수행 횟수
            "currentCount": 50, // 내가 수행한 횟수
            "groupName": null // 그룹 아니면 null
          },
        ]
      };
      List<dynamic> questJson = jsonData['quests'];
      List<QuestDetail> questList =
          questJson.map((quest) => QuestDetail.fromJson(quest)).toList();

      return questList;
    } catch (e) {
      rethrow;
    }
  }
}
