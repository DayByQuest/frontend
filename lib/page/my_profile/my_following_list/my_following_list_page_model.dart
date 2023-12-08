import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/model/class/error_exception.dart';
import 'package:flutter_application_1/provider/error_status_provider.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../model/class/user.dart';
import '../../../model/repository/user_repository.dart';

class MyFollowingListViewModel with ChangeNotifier {
  final ErrorStatusProvider _errorStatusProvider;
  final UserRepository _userRepository;
  final PagingController<int, User> _pagingController =
      PagingController(firstPageKey: -1);
  final List<User> _followingList = [];
  bool _hasNextPage = true;
  int _lastId = -1;
  final int _limit = 5;

  MyFollowingListViewModel({
    required UserRepository userRepository,
    required errorStatusProvider,
  })  : _userRepository = userRepository,
        _errorStatusProvider = errorStatusProvider {
    _pagingController.addPageRequestListener((lastId) {
      loadFollowingList(lastId);
    });
  }

  PagingController<int, User> get pagingController => _pagingController;
  List<User> get followingList => _followingList;

  Future<void> loadFollowingList(int lastId) async {
    if (!_hasNextPage) {
      return;
    }

    try {
      final result =
          await _userRepository.getRemoteFollowingList(lastId, _limit);
      final List<User> newFollowingList = result.$1;
      _hasNextPage = result.$2;
      _lastId = result.$3;
      _followingList.addAll(newFollowingList);

      if (_hasNextPage) {
        _pagingController.appendPage(newFollowingList, _lastId);
      } else {
        _pagingController.appendLastPage(newFollowingList);
      }
      debugPrint("loadFollowingList: 동작중! _lastId: $lastId");
    } on ErrorException catch (e) {
      _errorStatusProvider.setErrorStatus(true, e.message);
    } catch (e) {
      debugPrint('loadFollowingList error: ${e.toString()}');
    }
  }

  Future<void> postFollow(String username, int index) async {
    try {
      await _userRepository.postRemoteUserFollow(username);
      _followingList[index].following = !_followingList[index].following;
      debugPrint("postFollow: $index 교체!");
      notifyListeners();
    } on ErrorException catch (e) {
      _errorStatusProvider.setErrorStatus(true, e.message);
    } catch (e) {
      debugPrint('postFollow error: ${e.toString()}');
    }
  }

  Future<void> deleteFollow(String username, int index) async {
    try {
      debugPrint('deleteFollow username $username');
      await _userRepository.deleteRemoteUserFollow(username);
      _followingList[index].following = !_followingList[index].following;
      notifyListeners();
    } on ErrorException catch (e) {
      _errorStatusProvider.setErrorStatus(true, e.message);
    } catch (e) {
      debugPrint('deleteFollow error: ${e.toString()}');
    }
  }
}
