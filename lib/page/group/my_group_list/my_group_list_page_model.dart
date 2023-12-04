import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/class/error_exception.dart';
import 'package:flutter_application_1/model/class/group.dart';
import 'package:flutter_application_1/model/repository/group_repository.dart';
import 'package:flutter_application_1/page/common/Status.dart';
import 'package:flutter_application_1/provider/error_status_provider.dart';

class MyGroupListViewModel extends ChangeNotifier {
  final ErrorStatusProvider _errorStatusProvider;
  final GroupRepositoty _groupRepositoty;
  List<Group> groupList = [];
  Status status = Status.loading;

  MyGroupListViewModel({
    required GroupRepositoty groupRepositoty,
    required errorStatusProvider,
  })  : _groupRepositoty = groupRepositoty,
        _errorStatusProvider = errorStatusProvider;

  void load() async {
    try {
      debugPrint("load 시작!");
      groupList = await _groupRepositoty.getMyGroupList();
      status = Status.loaded;
      notifyListeners();
      debugPrint("loding됨!");
    } on ErrorException catch (e) {
      _errorStatusProvider.setErrorStatus(true, e.message);
    } catch (e) {
      debugPrint('load error: ${e.toString()}');
    }
  }

  void setStatusLoding() {
    status = Status.loading;
    notifyListeners();
  }
}
