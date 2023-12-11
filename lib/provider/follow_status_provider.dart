import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/class/error_exception.dart';
import 'package:flutter_application_1/model/class/user.dart';
import 'package:flutter_application_1/model/repository/group_repository.dart';
import 'package:flutter_application_1/model/repository/user_repository.dart';
import 'package:flutter_application_1/provider/error_status_provider.dart';

class FollowStatusProvider with ChangeNotifier {
  final ErrorStatusProvider _errorStatusProvider;
  final UserRepository _userRepository;
  final List<String> _followingList = [];

  FollowStatusProvider({
    required UserRepository userRepository,
    required errorStatusProvider,
  })  : _errorStatusProvider = errorStatusProvider,
        _userRepository = userRepository;

  bool hasUser(String username) {
    bool hasUser = _followingList.contains(username);

    return hasUser;
  }

  void updateFollowingList(User user) {
    if (!user.following || hasUser(user.username)) {
      return;
    }

    _followingList.add(user.username);
    notifyListeners();
    return;
  }

  void updateAllFollowingList(List<User> userList) {
    for (User user in userList) {
      updateFollowingList(user);
    }
  }

  Future<void> addFollowingUser(String username) async {
    if (hasUser(username)) {
      return;
    }

    try {
      await _userRepository.postRemoteUserFollow(username);
      _followingList.add(username);
      notifyListeners();
    } on ErrorException catch (e) {
      _errorStatusProvider.setErrorStatus(true, e.message);
    }

    return;
  }

  Future<void> unFollowUser(String username) async {
    if (!hasUser(username)) {
      return;
    }

    try {
      await _userRepository.deleteRemoteUserFollow(username);
      _followingList.remove(username);
      notifyListeners();
    } on ErrorException catch (e) {
      _errorStatusProvider.setErrorStatus(true, e.message);
    }

    return;
  }
}
