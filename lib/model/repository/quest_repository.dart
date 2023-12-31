import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/model/class/post.dart';
import 'package:flutter_application_1/model/class/post_images.dart';
import 'package:flutter_application_1/model/class/quest_detail.dart';
import 'package:flutter_application_1/model/dataSource/remote_data_source.dart';

class QuestRepository {
  final RemoteDataSource _RemoteDataSource;

  final String DOING = "DOING";
  final String FINISTHED = "FINISHED";
  final String CONTINUE = "CONTINUE";
  final String NOT = "NOT";

  QuestRepository({RemoteDataSource? remoteDataSource})
      : _RemoteDataSource = remoteDataSource ?? getIt.get<RemoteDataSource>();

  Future<List<QuestDetail>> getRemoteDoingQuest() async {
    try {
      return await _RemoteDataSource.getQuest(DOING);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<QuestDetail>> getRemoteFinishedQuest() async {
    try {
      return await _RemoteDataSource.getQuest(FINISTHED);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<QuestDetail>> getRemoteContinueQuest() async {
    try {
      return await _RemoteDataSource.getQuest(CONTINUE);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<QuestDetail>> getRemoteNewQuest() async {
    try {
      return await _RemoteDataSource.getQuest(NOT);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<QuestDetail>> getRemoteRecommendQuest() async {
    try {
      return await _RemoteDataSource.getRecommendQuest();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<QuestDetail>> getRemoteGroupQuestList(int groupId) async {
    try {
      return await _RemoteDataSource.getGroupQuestList(groupId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> postRemoteQuestAccept(int questId) async {
    try {
      return await _RemoteDataSource.postQuestAccept(questId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteRemoteQuestAccept(int questId) async {
    try {
      return await _RemoteDataSource.deleteQuestAccept(questId);
    } catch (e) {
      rethrow;
    }
  }

  Future<(PostImages, String)> getRemoteExampleQuest(int questId) async {
    try {
      return await _RemoteDataSource.getExampleQuest(questId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> patchFinishQuest(int questId) async {
    try {
      return await _RemoteDataSource.patchFinishQuest(questId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> patchRewardQuest(int questId) async {
    try {
      return await _RemoteDataSource.patchRewardQuest(questId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> patchRestartQuest(int questId) async {
    try {
      return await _RemoteDataSource.patchContinueQuest(questId);
    } catch (e) {
      rethrow;
    }
  }

  Future<(List<Post>, bool hasNextPage, int lastId)> getQuestPostList(
      int limit, int lastId, int questId) async {
    try {
      return await _RemoteDataSource.getQuestPostList(limit, lastId, questId);
    } catch (e) {
      rethrow;
    }
  }

  Future<(List<QuestDetail>, bool hasNextPage, int lastId)> getSearchQuestList(
      int lastId, int limit, String keyword) async {
    try {
      return await _RemoteDataSource.getSearchQuestList(lastId, limit, keyword);
    } catch (e) {
      rethrow;
    }
  }
}
