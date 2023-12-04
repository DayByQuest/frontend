import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/model/class/error_exception.dart';
import 'package:flutter_application_1/provider/error_status_provider.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../model/class/user.dart';
import '../../../model/repository/user_repository.dart';

class MyFollowerListViewModel with ChangeNotifier {
  final ErrorStatusProvider _errorStatusProvider;
  final UserRepository _userRepository;
  final PagingController<int, User> _pagingController =
      PagingController(firstPageKey: -1);
  final List<User> _followerList = [];
  bool _hasNextPage = true;
  int _lastId = -1;
  final int _limit = 5;

  MyFollowerListViewModel({
    required UserRepository userRepository,
    required errorStatusProvider,
  })  : _userRepository = userRepository,
        _errorStatusProvider = errorStatusProvider {
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
      debugPrint("loadFollowerList: start! _lastId: $lastId");
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
      debugPrint("loadFollowerList: end! _lastId: $lastId");
    } on ErrorException catch (e) {
      _errorStatusProvider.setErrorStatus(true, e.message);
    } catch (e) {
      debugPrint('loadFollowerList error: ${e.toString()}');
    }
  }

  Future<void> deleteFollower(String username, int index) async {
    try {
      await _userRepository.deleteRemoteFollower(username);
      _followerList[index].isDelete = true;
      notifyListeners();
    } on ErrorException catch (e) {
      _errorStatusProvider.setErrorStatus(true, e.message);
    } catch (e) {
      debugPrint('deleteFollow error: ${e.toString()}');
    }
  }
}
