import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/class/failed_post.dart';
import 'package:flutter_application_1/model/class/post_image.dart';
import 'package:flutter_application_1/model/class/quest_detail.dart';
import 'package:flutter_application_1/model/repository/group_repository.dart';
import 'package:flutter_application_1/model/repository/quest_repository.dart';
import 'package:flutter_application_1/page/common/Status.dart';

class GroupQuestJudgmentViewModel extends ChangeNotifier {
  final GroupRepositoty _groupRepositoty;
  final QuestRepository _questRepository;
  final int groupId;
  List<QuestDetail> groupQuestList = [];
  late QuestDetail? selectQuest;
  List<FailedPost> failedPostList = [];
  Status status = Status.loading;
  Status imageStatus = Status.loading;
  int imageLoadCount = 5;
  bool isDoneQuestJudge = false;
  bool _hasNextPage = true;

  GroupQuestJudgmentViewModel({
    required GroupRepositoty groupRepositoty,
    required QuestRepository questRepository,
    required this.groupId,
  })  : _groupRepositoty = groupRepositoty,
        _questRepository = questRepository;

  Future<void> load() async {
    try {
      groupQuestList = await _questRepository.getRemoteGroupQuestList(groupId);
      selectQuest = groupQuestList.isEmpty ? null : groupQuestList[0];
      status = Status.loaded;
      notifyListeners();
    } catch (e) {
      debugPrint('load error: ${e.toString()}');
    }
  }

  Future<void> getFailedGroupQuestList() async {
    if (!_hasNextPage) {
      return;
    }

    try {
      debugPrint("getFailedGroupQuestListModel start");
      int questId = selectQuest!.id;
      final postResult =
          await _groupRepositoty.getFailedGroupQuestList(questId);
      final List<FailedPost> newFailedPostList = postResult.$1;
      _hasNextPage = postResult.$2;
      failedPostList.addAll(newFailedPostList);
      imageStatus = Status.loaded;
      notifyListeners();
      debugPrint("getFailedGroupQuestListModel end");
      return;
    } catch (e) {
      debugPrint("getFailedGroupQuestList error: ${e.toString()}");
    }
  }

  Future<void> postJudgmentFail(int postId) async {
    try {
      debugPrint("postJudgmentFail start");
      await _groupRepositoty.postRemotePostJudgment(postId, false);
      debugPrint("postJudgmentFail end");
      return;
    } catch (e) {
      debugPrint("postJudgmentFail error: ${e.toString()}");
    }
  }

  Future<void> postJudgmentSuccess(int postId) async {
    try {
      debugPrint("postJudgmentSuccess start");
      await _groupRepositoty.postRemotePostJudgment(postId, true);
      debugPrint("postJudgmentSuccess end");
      return;
    } catch (e) {
      debugPrint("postJudgmentSuccess error: ${e.toString()}");
    }
  }

  void setSelectQuest(QuestDetail? newSelectQuest) {
    failedPostList.clear();
    selectQuest = newSelectQuest;
    imageStatus = Status.loading;
    isDoneQuestJudge = false;
    _hasNextPage = true;
    notifyListeners();
  }

  void changeImageLoadCount() async {
    if (imageLoadCount == 0) {
      //새로운 값 불러오기.
      imageStatus = Status.loading;
      imageLoadCount = 5;
      getFailedGroupQuestList();
      return;
    }

    imageLoadCount -= 1;
    return;
  }

  void setIsDoneQuestJudge() {
    isDoneQuestJudge = true;
    notifyListeners();
  }
}
