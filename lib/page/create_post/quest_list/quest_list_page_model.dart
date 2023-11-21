import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/class/quest_detail.dart';
import 'package:flutter_application_1/model/repository/quest_repository.dart';
import 'package:flutter_application_1/page/common/Status.dart';

class QuestListViewModel with ChangeNotifier {
  final QuestRepository _questRepository;
  List<QuestDetail> questList = [];
  int questTargetIndex = -1;
  int questId = -1;
  String questTitle = '';
  Status status = Status.loading;

  QuestListViewModel({
    required QuestRepository questRepository,
  }) : _questRepository = questRepository;

  void load() async {
    try {
      debugPrint("load 시작!");
      questList = await _questRepository.getRemoteDoingQuest();
      status = Status.loaded;
      notifyListeners();
      debugPrint("loding됨!");
    } catch (e) {
      debugPrint('load error: ${e.toString()}');
    }
  }

  void changeQuestTarget(bool isChecked, int targerIndex) {
    // 이미 체크했다면 -> 체크 취소
    if (isChecked) {
      questTargetIndex = -1;
      notifyListeners();
      return;
    }

    questTargetIndex = targerIndex;
    questId = questList[targerIndex].id;
    questTitle = questList[targerIndex].title;
    notifyListeners();
    return;
  }

  Map<String, dynamic> getSelctedQuest() {
    return {"questTitle": questTitle, "questId": questId};
  }
}
