import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/repository/user_repository.dart';

import '../../model/class/user.dart';
import '../common/Status.dart';
import './../../model/class/badge.dart' as BadgeClass;
import './../../model/class/tracker.dart';

class MyProfileViewModel with ChangeNotifier {
  final UserRepository _userRepository;
  MyProfileViewModel({required UserRepository userRepository})
      : _userRepository = userRepository;

  late User _user;
  late Tracker _tracker;
  late List<BadgeClass.Badge> _badge;
  Status status = Status.loading;

  User get user => _user;
  List<int> get tracker => _tracker.tracker;
  List<BadgeClass.Badge> get badge => _badge;

  void load() async {
    try {
      _user = await _userRepository.getRemoteMyProfile();
      _tracker = await _userRepository.getRemoteTracker("username");
      _badge = await _userRepository.getRemoteBadge("username");
      status = Status.loaded;
      notifyListeners();
      debugPrint("loding됨!");
    } catch (e) {
      // 추후 경고창으로 전환.
      debugPrint(e.toString());
    }
  }
}
