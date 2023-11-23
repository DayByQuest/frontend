import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/class/group.dart';
import 'package:flutter_application_1/model/class/quest_detail.dart';
import 'package:flutter_application_1/model/repository/group_repository.dart';
import 'package:flutter_application_1/model/repository/quest_repository.dart';
import 'package:flutter_application_1/page/common/Status.dart';

class GroupProfileViewModel extends ChangeNotifier {
  final GroupRepositoty _groupRepositoty;
  final QuestRepository _questRepository;
  final int groupId;
  Status status = Status.loading;
  late Group group;
  List<QuestDetail> groupQuestList = [];

  GroupProfileViewModel({
    required GroupRepositoty groupRepositoty,
    required QuestRepository questRepository,
    required this.groupId,
  })  : _groupRepositoty = groupRepositoty,
        _questRepository = questRepository;

  Future<void> load() async {
    try {
      group = await _groupRepositoty.getRemoteGroupProfile(groupId);
      groupQuestList = await _questRepository.getRemoteGroupQuestList(groupId);
      status = Status.loaded;
      notifyListeners();
    } catch (e) {
      debugPrint('load error: ${e.toString()}');
    }
  }

  Future<void> questAccept(int questId, int index) async {
    try {
      await _questRepository.postRemoteQuestAccept(questId);
      groupQuestList[index].state = QuestMap[QuestState.DOING] ?? 'NOT';
      notifyListeners();
    } catch (e) {
      debugPrint('questAccept error: ${e.toString()}');
    }
  }

  Future<void> questDelete(int questId, int index) async {
    try {
      await _questRepository.deleteRemoteQuestAccept(questId);
      groupQuestList[index].state = QuestMap[QuestState.NOT] ?? 'DOING';
      notifyListeners();
    } catch (e) {
      debugPrint('questDelete error: ${e.toString()}');
    }
  }
}
