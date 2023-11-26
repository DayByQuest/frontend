import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/class/error_exception.dart';
import 'package:flutter_application_1/model/class/group.dart';
import 'package:flutter_application_1/model/class/interest.dart';
import 'package:flutter_application_1/model/repository/group_repository.dart';
import 'package:flutter_application_1/model/repository/user_repository.dart';
import 'package:flutter_application_1/page/common/Status.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class GroupSearchViewModel with ChangeNotifier {
  final GroupRepositoty _groupRepositoty;
  final UserRepository _userRepository;

  final PageController controller = PageController();
  List<Interest> interest = [];
  String selectInterest = '';
  Status status = Status.loading;
  final PagingController<int, Group> pagingController =
      PagingController(firstPageKey: -1);
  final List<Group> interestedGroupList = [];
  bool _hasNextPage = true;
  int _lastId = -1;
  final int _limit = 10;
  bool _isClose = false;

  GroupSearchViewModel({
    required GroupRepositoty groupRepositoty,
    required UserRepository userRepository,
  })  : _groupRepositoty = groupRepositoty,
        _userRepository = userRepository {
    pagingController.addPageRequestListener((lastId) {
      loadInterestedGroupList(lastId);
    });
  }

  void getInterests() async {
    if (interest.isNotEmpty) {
      return;
    }

    try {
      debugPrint('getInterests start');
      interest = await _userRepository.getRemoteInterest();
      debugPrint('getInterests end');
      notifyListeners();
    } on Exception catch (e) {
      debugPrint('getInterests error: ${e.toString()}');
    }
  }

  void setInterest(String input) {
    selectInterest = input;
    notifyListeners();
  }

  void moveNextPage() {
    controller.nextPage(
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  Future<void> loadInterestedGroupList(int lastId) async {
    if (!_hasNextPage) {
      return;
    }

    try {
      final groupResult = await _groupRepositoty.getRemoteInterestedGroupList(
          _limit, lastId, selectInterest);
      debugPrint("loadInterestedGroupList 동작중! _lastId: $lastId");
      final List<Group> newGroupList = groupResult.$1;
      _hasNextPage = groupResult.$2;
      _lastId = groupResult.$3;

      interestedGroupList.addAll(newGroupList);

      if (_hasNextPage) {
        pagingController.appendPage(newGroupList, _lastId);
      } else {
        pagingController.appendLastPage(newGroupList);
      }

      debugPrint("loadInterestedGroupList: 동작 종료! _lastId: $_lastId");
    } catch (e) {
      debugPrint("loadInterestedGroupList error: ${e.toString()}");
    }
  }

  Future<void> joinGroup(int groupId, int index) async {
    try {
      await _groupRepositoty.remoteGroupJoin(groupId);
      interestedGroupList[index].isGroupMember = true;
      interestedGroupList[index].userCount += 1;
      notifyListeners();
    } catch (e) {
      debugPrint('joinGroup error: ${e.toString()}');
    }
  }

  Future<void> quitGroup(int groupId, int index) async {
    try {
      await _groupRepositoty.remoteQuitGroup(groupId);
      interestedGroupList[index].isGroupMember = false;
      interestedGroupList[index].userCount -= 1;
      notifyListeners();
    } catch (e) {
      debugPrint('quitGroup error: ${e.toString()}');
    }
  }

  void setIsClose(bool isClose) {
    _isClose = isClose;
    notifyListeners();
  }
}
