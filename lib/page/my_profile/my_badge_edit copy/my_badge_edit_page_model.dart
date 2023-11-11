import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/page/common/Status.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../model/class/user.dart';
import '../../../model/class/badge.dart' as BadgeClass;
import '../../../model/repository/user_repository.dart';

class MyBadgeEditViewModel with ChangeNotifier {
  final UserRepository _userRepository;
  Status _status = Status.loading;
  final PagingController<int, BadgeClass.Badge> _pagingController =
      PagingController(firstPageKey: 0);
  final List<BadgeClass.Badge> _myAllBadgeList = [];
  final List<BadgeClass.Badge> myCurrentBadList = [];
  bool _hasNextPage = true;
  int _lastId = -1;
  int draggingIndex = -1;

  MyBadgeEditViewModel({
    required UserRepository userRepository,
  }) : _userRepository = userRepository {
    _pagingController.addPageRequestListener((lastId) {
      loadAllBageList(lastId);
    });
    loadCurrentBageList();
  }

  PagingController<int, BadgeClass.Badge> get pagingController =>
      _pagingController;
  List<BadgeClass.Badge> get myAllBadgeList => _myAllBadgeList;
  Status get status => _status;

  Future<void> loadAllBageList(int lastId) async {
    if (!_hasNextPage) {
      return;
    }

    try {
      final result = await _userRepository.getRemoteMyBadge(lastId);
      final List<BadgeClass.Badge> newBadgeList = result.$1;
      _hasNextPage = result.$2;
      _lastId = result.$3;
      _myAllBadgeList.addAll(newBadgeList);

      if (_hasNextPage) {
        _pagingController.appendPage(newBadgeList, _lastId);
      } else {
        _pagingController.appendLastPage(newBadgeList);
      }
      debugPrint("loadAllBageList: 동작중! _lastId: $lastId");
    } catch (e) {
      debugPrint('loadAllBageList error: ${e.toString()}');
      _pagingController.error = e;
    }
  }

  Future<void> patchBadgeList() async {
    try {
      List<int> currentBadgeIdList = [];

      for (BadgeClass.Badge badge in myCurrentBadList) {
        currentBadgeIdList.add(badge.id);
      }

      await _userRepository.patchRemoteBadge(currentBadgeIdList);

      debugPrint("patchBadgeList 잘 동작함.");
      return;
    } catch (e) {
      debugPrint('patchBadgeList error: ${e.toString()}');
    }
  }

  Future<void> loadCurrentBageList() async {
    try {
      final List<BadgeClass.Badge> badgeList =
          await _userRepository.getRemoteBadge("username");
      myCurrentBadList.addAll(badgeList);
      debugPrint("loadCurrentBageList 잘 동작함.");
      _status = Status.loaded;
      notifyListeners();
    } catch (e) {
      debugPrint('loadCurrentBageList error: ${e.toString()}');
    }
  }

  void addNewBadge(BadgeClass.Badge badge) {
    if (!myCurrentBadList.contains(badge) && myCurrentBadList.length < 10) {
      myCurrentBadList.add(badge);
      debugPrint("추가!");
      notifyListeners();
    }
    return;
  }

  bool hasBadges(BadgeClass.Badge badge1, BadgeClass.Badge badge2) {
    return myCurrentBadList.contains(badge1) &&
        myCurrentBadList.contains(badge2);
  }

  void exchangeBadge(BadgeClass.Badge badge1, BadgeClass.Badge badge2) {
    int idx1 = myCurrentBadList.indexOf(badge1);
    int idx2 = myCurrentBadList.indexOf(badge2);
    myCurrentBadList[idx1] = badge2;
    myCurrentBadList[idx2] = badge1;
    debugPrint("교환!");
    notifyListeners();
    return;
  }

  void dropBadge(BadgeClass.Badge droppedBadge, int index) {
    BadgeClass.Badge badge = myCurrentBadList[index];

    if (hasBadges(droppedBadge, badge)) {
      exchangeBadge(droppedBadge, badge);
      return;
    }

    addNewBadge(droppedBadge);
    return;
  }

  void removeBadge(index) {
    myCurrentBadList.removeAt(index);
    notifyListeners();
  }
}
