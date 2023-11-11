import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/repository/user_repository.dart';

import '../../model/class/user.dart';
import '../common/Status.dart';
import './../../model/class/badge.dart' as BadgeClass;
import './../../model/class/tracker.dart';

class ProfileViewModel with ChangeNotifier {
  ProfileViewModel({
    required UserRepository userRepository,
    required this.username,
  }) : _userRepository = userRepository;

  final UserRepository _userRepository;
  final String username;
  late User _user;
  late Tracker _tracker;
  late List<BadgeClass.Badge> _badge;
  Status status = Status.loading;

  User get user => _user;
  List<int> get tracker => _tracker.tracker;
  List<BadgeClass.Badge> get badge => _badge;

  void load() async {
    try {
      _user = await _userRepository.getRemoteUserProfile(username);
      _tracker = await _userRepository.getRemoteTracker(username);
      _badge = await _userRepository.getRemoteBadge(username);
      status = Status.loaded;
      notifyListeners();
      debugPrint("loding됨!");
    } catch (e) {
      // 추후 경고창으로 전환.
      debugPrint(e.toString());
    }
  }

  Future<void> postFollow(String username) async {
    try {
      await _userRepository.postRemoteUserFollow(username);
      _user.following = true;
      debugPrint("postFollow:  교체!");
      notifyListeners();
    } catch (e) {
      debugPrint('postFollow error: ${e.toString()}');
    }
  }

  Future<void> deleteFollow(String username) async {
    try {
      await _userRepository.deleteRemoteUserFollow(username);
      _user.following = false;
      notifyListeners();
    } catch (e) {
      debugPrint('deleteFollow error: ${e.toString()}');
    }
  }
}