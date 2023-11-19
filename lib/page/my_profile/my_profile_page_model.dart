import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/repository/user_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
  bool _isClose = false;
  Status status = Status.loading;

  User get user => _user;
  List<int> get tracker => _tracker.tracker;
  List<BadgeClass.Badge> get badge => _badge;
  bool get isClose => _isClose;

  static String USER_NAME = dotenv.env['USER_NAME'] ?? '';

  void load() async {
    try {
      _user = await _userRepository.getRemoteMyProfile();
      _tracker = await _userRepository.getRemoteTracker(USER_NAME);
      _badge = await _userRepository.getRemoteBadge(USER_NAME);
      status = Status.loaded;
      notifyListeners();
      debugPrint("loding됨!");
    } catch (e) {
      // 추후 경고창으로 전환.
      debugPrint(e.toString());
    }
  }

  void setStatusLoding() {
    status = Status.loading;
  }

  void setIsClose(bool isClose) {
    _isClose = isClose;
    notifyListeners();
  }
}
