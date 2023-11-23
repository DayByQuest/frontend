import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/model/dataSource/remote_data_source.dart';
import 'package:image_picker_plus/image_picker_plus.dart';

class GroupRepositoty {
  final RemoteDataSource _RemoteDataSource;

  GroupRepositoty({RemoteDataSource? remoteDataSource})
      : _RemoteDataSource = remoteDataSource ?? getIt.get<RemoteDataSource>();

  Future<void> remoteGroupJoin(int groupId) {
    try {
      return _RemoteDataSource.postGroupJoin(groupId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> remoteDeleteGroupJoin(int groupId) {
    try {
      return _RemoteDataSource.deleteGroupJoin(groupId);
    } catch (e) {
      rethrow;
    }
  }

  Future<int> postRemoteCreateGroupQuest(
      List<SelectedByte> selectedByte, String description, int groupId) async {
    try {
      return _RemoteDataSource.createGroupQuest(
          selectedByte, description, groupId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createGroupQuestDetail(String title, String content,
      String expiredAt, String interest, String label, int questId) async {
    try {
      return _RemoteDataSource.createGroupQuestDetail(
          title, content, expiredAt, interest, label, questId);
    } catch (e) {
      rethrow;
    }
  }
}
