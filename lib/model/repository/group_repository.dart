import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/model/dataSource/remote_data_source.dart';

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
}
