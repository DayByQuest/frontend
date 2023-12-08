import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/class/error_exception.dart';
import 'package:flutter_application_1/model/class/quest_detail.dart';
import 'package:flutter_application_1/model/repository/quest_repository.dart';
import 'package:flutter_application_1/page/common/Status.dart';
import 'package:flutter_application_1/provider/error_status_provider.dart';

class QuestListViewModel with ChangeNotifier {
  final ErrorStatusProvider _errorStatusProvider;
  final QuestRepository _questRepository;
  List<QuestDetail> questList = [];
  int questTargetIndex = -1;
  int questId = -1;
  String questTitle = '';
  Status status = Status.loading;

  QuestListViewModel({
    required QuestRepository questRepository,
    required errorStatusProvider,
  })  : _questRepository = questRepository,
        _errorStatusProvider = errorStatusProvider;

  void load() async {
    try {
      debugPrint("load 시작!");
      questList = await _questRepository.getRemoteDoingQuest();
      status = Status.loaded;
      notifyListeners();
      debugPrint("loding됨!");
    } on ErrorException catch (e) {
      _errorStatusProvider.setErrorStatus(true, e.message);
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
