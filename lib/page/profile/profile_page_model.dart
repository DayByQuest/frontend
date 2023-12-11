import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/class/error_exception.dart';
import 'package:flutter_application_1/model/repository/user_repository.dart';
import 'package:flutter_application_1/provider/error_status_provider.dart';
import 'package:flutter_application_1/provider/follow_status_provider.dart';

import '../../model/class/user.dart';
import '../common/Status.dart';
import './../../model/class/badge.dart' as BadgeClass;
import './../../model/class/tracker.dart';

class ProfileViewModel with ChangeNotifier {
  final ErrorStatusProvider _errorStatusProvider;
  final FollowStatusProvider _followStatusProvider;
  final UserRepository _userRepository;
  final String username;
  late User _user;
  late Tracker _tracker;
  late List<BadgeClass.Badge> _badge;
  Status status = Status.loading;

  ProfileViewModel({
    required UserRepository userRepository,
    required this.username,
    required errorStatusProvider,
    required followStatusProvider,
  })  : _userRepository = userRepository,
        _errorStatusProvider = errorStatusProvider,
        _followStatusProvider = followStatusProvider;

  User get user => _user;
  List<int> get tracker => _tracker.tracker;
  List<BadgeClass.Badge> get badge => _badge;

  void load() async {
    try {
      _user = await _userRepository.getRemoteUserProfile(username);
      _tracker = await _userRepository.getRemoteTracker(username);
      _badge = await _userRepository.getRemoteBadge(username);
      _followStatusProvider.updateFollowingList(_user);
      status = Status.loaded;
      notifyListeners();
      debugPrint("loding됨!");
    } on ErrorException catch (e) {
      _errorStatusProvider.setErrorStatus(true, e.message);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> postFollow(String username) async {
    await _followStatusProvider.addFollowingUser(username);
  }

  Future<void> deleteFollow(String username) async {
    await _followStatusProvider.unFollowUser(username);
  }
}
