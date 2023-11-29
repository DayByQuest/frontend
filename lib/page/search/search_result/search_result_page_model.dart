import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/class/group.dart';
import 'package:flutter_application_1/model/class/quest_detail.dart';
import 'package:flutter_application_1/model/class/user.dart';
import 'package:flutter_application_1/model/repository/group_repository.dart';
import 'package:flutter_application_1/model/repository/quest_repository.dart';
import 'package:flutter_application_1/model/repository/user_repository.dart';
import 'package:flutter_application_1/page/common/Status.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class SearchResultViewModel extends ChangeNotifier {
  final QuestRepository _questRepository;
  final UserRepository _userRepository;
  final GroupRepositoty _groupRepositoty;
  final String keyword;
  Status status = Status.loading;
  late TextEditingController textEditingController;
  bool messageStatus = false;
  String message = '';
  bool hasChange = false;
  final int _limit = 5;

  final PagingController<int, User> userPagingController =
      PagingController(firstPageKey: -1);
  final List<User> searchUserList = [];
  bool _searchUserhasNextPage = true;
  int _searchUserlastId = -1;

  final PagingController<int, Group> groupPagingController =
      PagingController(firstPageKey: -1);
  final List<Group> searchGroupList = [];
  bool _searchGrouphasNextPage = true;
  int _searchGrouplastId = -1;

  final PagingController<int, QuestDetail> questPagingController =
      PagingController(firstPageKey: -1);
  final List<QuestDetail> searchQuestList = [];
  bool _searchQuesthasNextPage = true;
  int _searchQuestlastId = -1;

  SearchResultViewModel({
    required QuestRepository questRepository,
    required UserRepository userRepository,
    required GroupRepositoty groupRepositoty,
    required this.keyword,
  })  : _questRepository = questRepository,
        _userRepository = userRepository,
        _groupRepositoty = groupRepositoty {
    textEditingController = TextEditingController(text: keyword);
    userPagingController.addPageRequestListener((lastId) {
      loadSearchUserList(lastId);
    });

    groupPagingController.addPageRequestListener((lastId) {
      loadSearchGroupList(lastId);
    });

    questPagingController.addPageRequestListener((lastId) {
      loadSearchQuestList(lastId);
    });
  }

  Future<void> loadSearchUserList(int lastId) async {
    if (!_searchUserhasNextPage) {
      return;
    }

    try {
      final result =
          await _userRepository.getSearchUserList(lastId, _limit, keyword);
      final List<User> newSearchList = result.$1;
      _searchUserhasNextPage = result.$2;
      _searchUserlastId = result.$3;
      searchUserList.addAll(newSearchList);

      if (_searchUserhasNextPage) {
        userPagingController.appendPage(newSearchList, _searchUserlastId);
      } else {
        userPagingController.appendLastPage(newSearchList);
      }
      debugPrint("loadSearchUserList: 동작중! _lastId: $lastId");
    } catch (e) {
      debugPrint('loadSearchUserList error: ${e.toString()}');
    }
  }

  Future<void> postFollow(String username, int index) async {
    try {
      await _userRepository.postRemoteUserFollow(username);
      searchUserList[index].following = !searchUserList[index].following;
      debugPrint("postFollow: $index 교체!");
      notifyListeners();
    } catch (e) {
      debugPrint('postFollow error: ${e.toString()}');
    }
  }

  Future<void> deleteFollow(String username, int index) async {
    try {
      debugPrint('deleteFollow username $username');
      await _userRepository.deleteRemoteUserFollow(username);
      searchUserList[index].following = !searchUserList[index].following;
      notifyListeners();
    } catch (e) {
      debugPrint('deleteFollow error: ${e.toString()}');
    }
  }

  Future<void> loadSearchGroupList(int lastId) async {
    if (!_searchGrouphasNextPage) {
      return;
    }

    try {
      final groupResult =
          await _groupRepositoty.getSearchGroupList(lastId, _limit, keyword);
      debugPrint("loadSearchGroupList 동작중! _lastId: $lastId");
      final List<Group> newGroupList = groupResult.$1;
      _searchGrouphasNextPage = groupResult.$2;
      _searchGrouplastId = groupResult.$3;

      searchGroupList.addAll(newGroupList);

      if (_searchGrouphasNextPage) {
        groupPagingController.appendPage(newGroupList, _searchGrouplastId);
      } else {
        groupPagingController.appendLastPage(newGroupList);
      }

      debugPrint("loadSearchGroupList: 동작 종료! _lastId: $_searchGrouplastId");
    } catch (e) {
      debugPrint("loadSearchGroupList error: ${e.toString()}");
    }
  }

  Future<void> joinGroup(int groupId, int index) async {
    try {
      await _groupRepositoty.remoteGroupJoin(groupId);
      searchGroupList[index].isGroupMember = true;
      searchGroupList[index].userCount += 1;
      notifyListeners();
    } catch (e) {
      debugPrint('joinGroup error: ${e.toString()}');
    }
  }

  Future<void> quitGroup(int groupId, int index) async {
    try {
      await _groupRepositoty.remoteQuitGroup(groupId);
      searchGroupList[index].isGroupMember = false;
      searchGroupList[index].userCount -= 1;
      notifyListeners();
    } catch (e) {
      debugPrint('quitGroup error: ${e.toString()}');
    }
  }

  Future<void> loadSearchQuestList(int lastId) async {
    if (!_searchQuesthasNextPage) {
      return;
    }

    try {
      final questResult =
          await _questRepository.getSearchQuestList(lastId, _limit, keyword);
      debugPrint("loadSearchQuestList 동작중! _lastId: $lastId");
      final List<QuestDetail> newQusetList = questResult.$1;
      _searchQuesthasNextPage = questResult.$2;
      _searchQuestlastId = questResult.$3;

      searchQuestList.addAll(newQusetList);

      if (_searchQuesthasNextPage) {
        questPagingController.appendPage(newQusetList, _searchQuestlastId);
      } else {
        questPagingController.appendLastPage(newQusetList);
      }

      debugPrint("loadSearchQuestList: 동작 종료! _lastId: $_searchQuestlastId");
    } catch (e) {
      debugPrint("loadSearchQuestList error: ${e.toString()}");
    }
  }

  Future<void> acceptQuest(int questId, int index) async {
    try {
      await _questRepository.postRemoteQuestAccept(questId);
      searchQuestList[index].canShowAnimation = true;
      notifyListeners();
      return;
    } catch (e) {
      debugPrint('acceptQuest error: ${e.toString()}');
    }
  }

  void restartQuest(int questId, int index) async {
    try {
      await _questRepository.patchRestartQuest(questId);
      hasChange = true;
      searchQuestList[index].canShowAnimation = true;
      notifyListeners();
      return;
    } catch (e) {
      debugPrint('completeQuest error: ${e.toString()}');
    }
  }
}
