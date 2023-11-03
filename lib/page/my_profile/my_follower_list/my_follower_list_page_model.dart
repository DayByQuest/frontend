import 'package:flutter/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../model/class/user.dart';
import '../../../model/repository/user_repository.dart';

class MyFollowerListViewModel with ChangeNotifier {
  final UserRepository _userRepository;
  final PagingController<int, User> _pagingController =
      PagingController(firstPageKey: 0);
  final List<User> _followerList = [];
  bool _hasNextPage = true;
  int _lastId = -1;
  final int _limit = 5;

  MyFollowerListViewModel({
    required UserRepository userRepository,
  }) : _userRepository = userRepository {
    _pagingController.addPageRequestListener((lastId) {
      loadFollowerList(lastId);
    });
  }

  PagingController<int, User> get pagingController => _pagingController;
  List<User> get followerList => _followerList;

  Future<void> loadFollowerList(int lastId) async {
    if (!_hasNextPage) {
      return;
    }

    try {
      final result =
          await _userRepository.getRemoteFollowerList(lastId, _limit);
      final List<User> newFollowerList = result.$1;
      _hasNextPage = result.$2;
      _lastId = result.$3;
      _followerList.addAll(newFollowerList);

      if (_hasNextPage) {
        _pagingController.appendPage(newFollowerList, _lastId);
      } else {
        _pagingController.appendLastPage(newFollowerList);
      }
      debugPrint("loadFollowerList: 동작중! _lastId: $lastId");
    } catch (e) {
      debugPrint('loadFollowerList error: ${e.toString()}');
    }
  }

  Future<void> postFollow(String username, int index) async {
    try {
      await _userRepository.postRemoteUserFollow(username);
      _followerList[index].following = !_followerList[index].following;
      debugPrint("postFollow: $index 교체!");
      notifyListeners();
    } catch (e) {
      debugPrint('postFollow error: ${e.toString()}');
    }
  }

  Future<void> deleteFollow(String username, int index) async {
    try {
      await _userRepository.deleteRemoteUserFollow(username);
      _followerList[index].following = !_followerList[index].following;
      notifyListeners();
    } catch (e) {
      debugPrint('deleteFollow error: ${e.toString()}');
    }
  }
}
