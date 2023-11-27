import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/class/quest_detail.dart';
import 'package:flutter_application_1/model/repository/quest_repository.dart';
import 'package:flutter_application_1/page/common/Status.dart';

enum ChangeStatus {
  doingQuest,
  newQuest,
  finishQuest,
  nothing,
}

class QuestViewModel extends ChangeNotifier {
  final QuestRepository _questRepository;
  Status status = Status.loading;
  List<QuestDetail> doingQuestList = [];
  List<QuestDetail> newQuestList = [];
  List<QuestDetail> finishedQuestList = [];
  bool messageStatus = false;
  String message = '';
  bool hasChange = false;
  ChangeStatus changeStatus = ChangeStatus.nothing;

  QuestViewModel({
    required QuestRepository questRepository,
  }) : _questRepository = questRepository;

  Future<void> load() async {
    try {
      debugPrint('load start: ');
      finishedQuestList.clear();
      List<dynamic> results = await Future.wait([
        _questRepository.getRemoteDoingQuest(),
        _questRepository.getRemoteNewQuest(),
        _questRepository.getRemoteFinishedQuest(),
        _questRepository.getRemoteRecommendQuest(),
      ]);
      doingQuestList.clear();
      doingQuestList = results[0];
      newQuestList.clear();
      newQuestList = results[1];
      newQuestList.addAll(results[3]);
      finishedQuestList.clear();
      finishedQuestList.addAll(results[2]);
      status = Status.loaded;
      notifyListeners();
      debugPrint('load end: ');
      return;
    } catch (e) {
      debugPrint('load error: ${e.toString()}');
    }
  }

  void setMessageStatus(bool status, String message) {
    messageStatus = status;
    this.message = message;
    notifyListeners();
  }

  Future<void> completeQuest(int questId, int index) async {
    try {
      await _questRepository.patchFinishQuest(questId);
      await rewardQuest(questId, index);
      hasChange = true;
      changeStatus = ChangeStatus.doingQuest;
      doingQuestList[index].canShowAnimation = true;
      notifyListeners();
      return;
    } catch (e) {
      debugPrint('completeQuest error: ${e.toString()}');
    }
  }

  Future<void> rewardQuest(int questId, int index) async {
    try {
      QuestDetail targetQuest = doingQuestList[index];

      if (targetQuest.rewardCount != null) {
        await _questRepository.patchRewardQuest(questId);
      }

      hasChange = true;

      messageStatus = true;

      if (targetQuest.rewardCount != null) {
        message =
            '축하합니다. 퀘스트를 완료하고 뱃지를 획득하셨습니다. 퀘스트는 완료 탭에서 재개 버튼을 눌러 재시작할 수 있습니다.';
      } else {
        message = '축하합니다. 퀘스트를 완료하셨습니다. 퀘스트는 완료 탭에서 재개 버튼을 눌러 재시작할 수 있습니다.';
      }

      return;
    } catch (e) {
      debugPrint('rewardQuest error: ${e.toString()}');
    }
  }

  void restartQuest(int questId, int index) async {
    try {
      await _questRepository.patchRestartQuest(questId);
      hasChange = true;
      changeStatus = ChangeStatus.finishQuest;
      finishedQuestList[index].canShowAnimation = true;
      notifyListeners();
      return;
    } catch (e) {
      debugPrint('completeQuest error: ${e.toString()}');
    }
  }

  Future<void> acceptQuest(int questId, int index) async {
    try {
      await _questRepository.postRemoteQuestAccept(questId);
      hasChange = true;
      changeStatus = ChangeStatus.newQuest;
      newQuestList[index].canShowAnimation = true;
      notifyListeners();
      return;
    } catch (e) {
      debugPrint('completeQuest error: ${e.toString()}');
    }
  }

  Future<void> cancelAcceptQuest(int questId, int index) async {
    try {
      await _questRepository.deleteRemoteQuestAccept(questId);
      hasChange = true;
      changeStatus = ChangeStatus.doingQuest;
      doingQuestList[index].canShowAnimation = true;
      notifyListeners();
      return;
    } catch (e) {
      debugPrint('completeQuest error: ${e.toString()}');
    }
  }

  bool isRefreshDoingQuset() {
    if (!hasChange) {
      return false;
    }

    if (changeStatus == ChangeStatus.nothing ||
        changeStatus == ChangeStatus.doingQuest) {
      return false;
    }

    return true;
  }

  bool isRefreshNewQuset() {
    if (!hasChange) {
      return false;
    }

    if (changeStatus == ChangeStatus.nothing ||
        changeStatus == ChangeStatus.newQuest) {
      return false;
    }

    return true;
  }

  bool isRefreshFinishQuset() {
    if (!hasChange) {
      return false;
    }

    if (changeStatus == ChangeStatus.nothing ||
        changeStatus == ChangeStatus.finishQuest) {
      return false;
    }

    return true;
  }

  void refresh() {
    notifyListeners();
  }

  void setChangeStatus(ChangeStatus changeStatus, bool hasChange) async {
    await load();
    this.hasChange = hasChange;
    this.changeStatus = changeStatus;
    notifyListeners();
  }
}
