import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/model/class/error_exception.dart';
import 'package:flutter_application_1/model/class/group.dart';
import 'package:flutter_application_1/model/class/quest_detail.dart';
import 'package:flutter_application_1/model/repository/group_repository.dart';
import 'package:flutter_application_1/model/repository/quest_repository.dart';
import 'package:flutter_application_1/page/common/Status.dart';
import 'package:flutter_application_1/provider/error_status_provider.dart';
import 'package:flutter_application_1/provider/groupJoin_status_provider.dart';

class GroupProfileViewModel extends ChangeNotifier {
  final ErrorStatusProvider _errorStatusModel;
  final GroupRepositoty _groupRepositoty;
  final QuestRepository _questRepository;
  final GroupJoinStatusProvider _groupJoinStatusProvider;
  final int groupId;
  Status status = Status.loading;
  late Group group;
  List<QuestDetail> groupQuestList = [];

  GroupProfileViewModel({
    required GroupRepositoty groupRepositoty,
    required QuestRepository questRepository,
    required ErrorStatusProvider errorStatusModel,
    required groupJoinStatusProvider,
    required this.groupId,
  })  : _groupRepositoty = groupRepositoty,
        _questRepository = questRepository,
        _errorStatusModel = errorStatusModel,
        _groupJoinStatusProvider = groupJoinStatusProvider;

  Future<void> load() async {
    try {
      group = await _groupRepositoty.getRemoteGroupProfile(groupId);
      groupQuestList = await _questRepository.getRemoteGroupQuestList(groupId);
      status = Status.loaded;
      _groupJoinStatusProvider.updateGroupList(group);
      notifyListeners();
    } on ErrorException catch (e) {
      _errorStatusModel.setErrorStatus(true, e.message);
    } catch (e) {
      debugPrint('load error: ${e.toString()}');
    }
  }

  Future<void> joinGroup(int groupId) async {
    await _groupJoinStatusProvider.joinGroup(groupId);
    group.userCount += 1;
    notifyListeners();
  }

  Future<void> quitGroup(int groupId) async {
    await _groupJoinStatusProvider.quitGroup(groupId);
    group.userCount -= 1;
    notifyListeners();
  }

  Future<void> questAccept(int questId, int index) async {
    try {
      await _questRepository.postRemoteQuestAccept(questId);
      groupQuestList[index].state = QuestMap[QuestState.DOING] ?? 'NOT';
      notifyListeners();
    } on ErrorException catch (e) {
      _errorStatusModel.setErrorStatus(true, e.message);
    } catch (e) {
      debugPrint('questAccept error: ${e.toString()}');
    }
  }

  Future<void> questDelete(int questId, int index) async {
    try {
      await _questRepository.deleteRemoteQuestAccept(questId);
      groupQuestList[index].state = QuestMap[QuestState.NOT] ?? 'DOING';
      notifyListeners();
    } on ErrorException catch (e) {
      _errorStatusModel.setErrorStatus(true, e.message);
    } catch (e) {
      debugPrint('questDelete error: ${e.toString()}');
    }
  }
}
