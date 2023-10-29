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
  Future<(List<BadgeClass.Badge>, bool hasNextPage)> getMyBadge(
      int page) async {
    String name = "김김승승태태";
    String imageUrl = "https://picsum.photos/200/300";
    String id = "aaaa";
    String acquiredAt = "2000/00/00";

    List<BadgeClass.Badge> badges = [];
    for (int i = 0; i < 10; i++) {
      BadgeClass.Badge newBadge = BadgeClass.Badge(
          name: name, imageUrl: imageUrl, id: id, acquiredAt: acquiredAt);
      badges.add(newBadge);
    }
    return Future.delayed(Duration(seconds: 1), () {
      return (badges, true);
    });
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
          name: name, imageUrl: imageUrl, id: id, acquiredAt: acquiredAt);
      badges.add(newBadge);
    }

    return Future.delayed(Duration(seconds: 1), () {
      return badges;
    });
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
}
