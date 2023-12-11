import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/class/error_exception.dart';
import 'package:flutter_application_1/model/class/group.dart';
import 'package:flutter_application_1/model/class/post.dart';
import 'package:flutter_application_1/model/repository/group_repository.dart';
import 'package:flutter_application_1/model/repository/post_repository.dart';
import 'package:flutter_application_1/provider/error_status_provider.dart';

class GroupJoinStatusProvider with ChangeNotifier {
  final ErrorStatusProvider _errorStatusProvider;
  final GroupRepositoty _groupRepositoty;
  final List<int> _groupList = [];

  GroupJoinStatusProvider({
    required GroupRepositoty groupRepositoty,
    required errorStatusProvider,
  })  : _errorStatusProvider = errorStatusProvider,
        _groupRepositoty = groupRepositoty;

  bool hasjoinGroupList(int groupId) {
    bool hasGroup = _groupList.contains(groupId);

    return hasGroup;
  }

  void updateGroupList(Group group) {
    if (hasjoinGroupList(group.groupId) || !group.isJoin) {
      return;
    }

    _groupList.add(group.groupId);
    notifyListeners();
    return;
  }

  void updateAllGroupList(List<Group> groupList) {
    for (Group group in groupList) {
      updateGroupList(group);
    }

    return;
  }

  Future<void> joinGroup(int groupId) async {
    if (hasjoinGroupList(groupId)) {
      return;
    }

    try {
      await _groupRepositoty.remoteGroupJoin(groupId);
      _groupList.add(groupId);
      notifyListeners();
    } on ErrorException catch (e) {
      _errorStatusProvider.setErrorStatus(true, e.message);
    }
  }

  Future<void> quitGroup(int groupId) async {
    if (!hasjoinGroupList(groupId)) {
      return;
    }

    try {
      await _groupRepositoty.remoteQuitGroup(groupId);
      _groupList.remove(groupId);
      notifyListeners();
    } on ErrorException catch (e) {
      _errorStatusProvider.setErrorStatus(true, e.message);
    }
  }
}
