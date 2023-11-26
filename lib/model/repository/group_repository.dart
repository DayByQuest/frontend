import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/model/class/failed_post.dart';
import 'package:flutter_application_1/model/class/group.dart';
import 'package:flutter_application_1/model/class/post.dart';
import 'package:flutter_application_1/model/class/user.dart';
import 'package:flutter_application_1/model/dataSource/remote_data_source.dart';
import 'package:image_picker/image_picker.dart';
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

  Future<List<Group>> getMyGroupList() async {
    try {
      return _RemoteDataSource.getMyGroupList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Group> getRemoteGroupProfile(int groupId) async {
    try {
      return _RemoteDataSource.getGroupProfile(groupId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> remoteJoinGroup(int groupId) async {
    try {
      return _RemoteDataSource.joinGroup(groupId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> remoteQuitGroup(int groupId) async {
    try {
      return _RemoteDataSource.quitGroup(groupId);
    } catch (e) {
      rethrow;
    }
  }

  Future<(List<Post>, bool hasNextPage, int lastId)> getRemoteGroupPost(
      int limit, int lastId, int groupId) async {
    try {
      return _RemoteDataSource.getGroupPost(limit, lastId, groupId);
    } catch (e) {
      rethrow;
    }
  }

  Future<(List<User>, bool hasNextPage, int lastId)> getRemoteGroupMemberList(
      int limit, int lastId, int groupId) async {
    try {
      return _RemoteDataSource.getGroupMemberList(limit, lastId, groupId);
    } catch (e) {
      rethrow;
    }
  }

  Future<(List<FailedPost>, bool hasNextPage)> getFailedGroupQuestList(
      int questId) async {
    try {
      return _RemoteDataSource.getFailedGroupQuestList(questId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> postRemotePostJudgment(int postId, bool approval) async {
    try {
      return _RemoteDataSource.postPostJudgment(postId, approval);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getRemoteGroupNameDuplication(String groupName) async {
    try {
      return _RemoteDataSource.getGroupNameDuplication(groupName);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createGroup(
      String interest, String name, String description, XFile image) async {
    try {
      return _RemoteDataSource.createGroup(
        interest,
        name,
        description,
        image,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<(List<Group>, bool hasNextPage, int lastId)>
      getRemoteInterestedGroupList(
          int limit, int lastId, String interest) async {
    try {
      return _RemoteDataSource.getInterestedGroupList(limit, lastId, interest);
    } catch (e) {
      rethrow;
    }
  }
}
