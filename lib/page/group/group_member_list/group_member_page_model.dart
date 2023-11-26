import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/class/user.dart';
import 'package:flutter_application_1/model/repository/group_repository.dart';
import 'package:flutter_application_1/model/repository/post_repository.dart';
import 'package:flutter_application_1/model/repository/user_repository.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../model/class/post.dart';
import '../../../model/class/post_image.dart';

class GroupMemberListViewModel with ChangeNotifier {
  final GroupRepositoty _groupRepositoty;
  final PagingController<int, User> _pagingController =
      PagingController(firstPageKey: -1);
  final List<User> userList = [];
  final int groupId;
  bool _hasNextPage = true;
  int _lastId = -1;
  final int _limit = 10;

  GroupMemberListViewModel({
    required this.groupId,
    required GroupRepositoty groupRepositoty,
  }) : _groupRepositoty = groupRepositoty {
    _pagingController.addPageRequestListener((int lastId) {
      debugPrint('lastId: $lastId');
      loadUserList(lastId);
    });
  }

  PagingController<int, User> get pagingController => _pagingController;

  Future<void> loadUserList(int lastId) async {
    if (!_hasNextPage) {
      return;
    }

    try {
      final result = await _groupRepositoty.getRemoteGroupMemberList(
          _limit, lastId, groupId);
      final List<User> newUserList = result.$1;
      _hasNextPage = result.$2;
      _lastId = result.$3;

      if (_hasNextPage) {
        _pagingController.appendPage(newUserList, _lastId);
      } else {
        _pagingController.appendLastPage(newUserList);
      }

      userList.addAll(newUserList);

      debugPrint("loadUserList: 동작중! _lastId: $_lastId");
    } catch (e) {
      debugPrint('loadUserList error: ${e.toString()}');
    }
  }
}
