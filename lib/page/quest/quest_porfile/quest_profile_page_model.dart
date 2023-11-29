import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/class/error_exception.dart';
import 'package:flutter_application_1/model/class/interest.dart';
import 'package:flutter_application_1/model/class/post_image.dart';
import 'package:flutter_application_1/model/class/post_images.dart';
import 'package:flutter_application_1/model/class/quest_detail.dart';
import 'package:flutter_application_1/model/repository/group_repository.dart';
import 'package:flutter_application_1/model/repository/quest_repository.dart';
import 'package:flutter_application_1/model/repository/user_repository.dart';
import 'package:flutter_application_1/page/common/Status.dart';
import 'package:flutter_application_1/page/quest/quest_page_model.dart';
import 'package:image_picker/image_picker.dart';

class QuestProfileViewModel with ChangeNotifier {
  final QuestRepository _questRepository;
  final int questId;
  final QuestDetail quest;
  Status status = Status.loading;
  String description = '';
  late PostImages exampleImages;
  bool messageStatus = false;
  String message = '';
  bool hasChange = false;
  ChangeStatus changeStatus = ChangeStatus.nothing;

  QuestProfileViewModel({
    required QuestRepository questRepository,
    required this.questId,
    required this.quest,
  }) : _questRepository = questRepository;

  void load() async {
    try {
      final result = await _questRepository.getRemoteExampleQuest(questId);
      exampleImages = result.$1;
      description = result.$2;
      status = Status.loaded;
      notifyListeners();
      debugPrint('load end: ');
      return;
    } catch (e) {
      debugPrint('load error: ${e.toString()}');
    }
  }

  Future<void> changeCurImageIndex(int nextImageIndex) async {
    try {
      exampleImages.index = nextImageIndex;
      notifyListeners();
      return;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> completeQuest(int questId) async {
    try {
      await _questRepository.patchFinishQuest(questId);
      await rewardQuest(questId);
      hasChange = true;
      changeStatus = ChangeStatus.doingQuest;
      quest.canShowAnimation = true;
      notifyListeners();
      return;
    } catch (e) {
      debugPrint('completeQuest error: ${e.toString()}');
    }
  }

  Future<void> rewardQuest(int questId) async {
    try {
      if (quest.rewardCount != null) {
        await _questRepository.patchRewardQuest(questId);
      }

      hasChange = true;

      messageStatus = true;

      if (quest.rewardCount != null) {
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

  Future<void> cancelAcceptQuest(int questId) async {
    try {
      await _questRepository.deleteRemoteQuestAccept(questId);
      hasChange = true;
      changeStatus = ChangeStatus.doingQuest;
      quest.canShowAnimation = true;
      notifyListeners();
      return;
    } catch (e) {
      debugPrint('completeQuest error: ${e.toString()}');
    }
  }

  Future<void> acceptQuest(int questId) async {
    try {
      await _questRepository.postRemoteQuestAccept(questId);
      hasChange = true;
      changeStatus = ChangeStatus.newQuest;
      quest.canShowAnimation = true;
      notifyListeners();
      return;
    } catch (e) {
      debugPrint('acceptQuest error: ${e.toString()}');
    }
  }

  void restartQuest(int questId) async {
    try {
      await _questRepository.patchRestartQuest(questId);
      hasChange = true;
      changeStatus = ChangeStatus.finishQuest;
      quest.canShowAnimation = true;
      notifyListeners();
      return;
    } catch (e) {
      debugPrint('completeQuest error: ${e.toString()}');
    }
  }
}
