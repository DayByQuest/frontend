import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/class/group.dart';
import 'package:flutter_application_1/model/repository/group_repository.dart';
import 'package:flutter_application_1/page/common/Status.dart';

class MyGroupListViewModel extends ChangeNotifier {
  final GroupRepositoty _groupRepositoty;
  List<Group> groupList = [];
  Status status = Status.loading;

  MyGroupListViewModel({
    required GroupRepositoty groupRepositoty,
  }) : _groupRepositoty = groupRepositoty;

  void load() async {
    try {
      debugPrint("load 시작!");
      groupList = await _groupRepositoty.getMyGroupList();
      status = Status.loaded;
      notifyListeners();
      debugPrint("loding됨!");
    } catch (e) {
      debugPrint('load error: ${e.toString()}');
    }
  }

  void setStatusLoding() {
    status = Status.loading;
    notifyListeners();
  }
}
