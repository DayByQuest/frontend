import 'package:flutter_application_1/main.dart';
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
      return _RemoteDataSource.getQuest(DOING);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<QuestDetail>> getRemoteFinishedQuest() async {
    try {
      return _RemoteDataSource.getQuest(FINISTHED);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<QuestDetail>> getRemoteContinueQuest() async {
    try {
      return _RemoteDataSource.getQuest(CONTINUE);
    } catch (e) {
      rethrow;
    }
  }
}
