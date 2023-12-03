import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/repository/group_repository.dart';
import 'package:flutter_application_1/page/common/Status.dart';
import 'package:image_picker_plus/image_picker_plus.dart';

class DescribeImagesViewModel with ChangeNotifier {
  final GroupRepositoty _groupRepositoty;

  int questId = 0;
  final int groupId;
  String description = "";
  final List<SelectedByte> selectedBytes;
  final SelectedImagesDetails details;
  Status status = Status.loaded;

  DescribeImagesViewModel({
    required GroupRepositoty groupRepositoty,
    required this.selectedBytes,
    required this.details,
    required this.groupId,
  }) : _groupRepositoty = groupRepositoty;

  Future<int> createGroupQuest() async {
    try {
      debugPrint('createGroupQuest: 시작! description: $description');
      status = Status.loading;
      notifyListeners();
      questId = await _groupRepositoty.postRemoteCreateGroupQuest(
          selectedBytes, description, groupId);
      debugPrint('createGroupQuest: 종료! questId: $questId');
      status = Status.loaded;
      notifyListeners();

      return questId;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return -1;
    }
  }

  void setDescription(String input) {
    description = input;
    notifyListeners();
  }
}
