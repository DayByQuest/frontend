import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import './remote_data_source.dart';
import 'package:mockito/mockito.dart';
import './../class/user.dart';
import './../class/badge.dart' as BadgeClass;
import './../class/tracker.dart';

class MockDataSource extends Mock implements RemoteDataSource {
  @override
  Future<User> getMyProfile() async {
    String username = "abcdefghijklmno";
    String name = "김김승승태태";
    String imageUrl = "https://picsum.photos/200/300";
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
    String imageUrl = "https://picsum.photos/200/300";
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
    String imageUrl = "https://picsum.photos/200/300";
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
    String imageUrl = "https://picsum.photos/200/300";
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
  Future<List<String>> getInterest() async {
    List<String> interest = [
      "사진",
      "운동",
      "음식",
      "생활습관",
      "반려동식물",
      "개발",
      "독서",
      "공부"
    ];
    return interest;
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
    String imageUrl = "https://picsum.photos/200/300";
    bool following = 50 < Random.secure().nextInt(100);

    for (int i = 0; i < 10; i++) {
      User user = User(
        imageUrl: imageUrl,
        name: name,
        username: username,
        follwing: following,
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
    String imageUrl = "https://picsum.photos/200/300";
    bool following = 50 < Random.secure().nextInt(100);

    for (int i = 0; i < 10; i++) {
      User user = User(
        imageUrl: imageUrl,
        name: name,
        username: username,
        follwing: following,
      );
      followerList.add(user);
    }

    return (followerList, hasNextPage, lastId + 1);
  }

  @override
  Future<void> postUserFollow(String username) async {
    debugPrint('postUserFollow: $username 잘 전송됨, 팔로우 완료!');
  }

  @override
  Future<void> deleteUserfollow(String username) async {
    debugPrint('deleteUserfollow: $username 잘 전송됨, 언팔로우 완료!');
  }
}
