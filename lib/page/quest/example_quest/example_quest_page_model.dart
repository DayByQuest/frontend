import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/class/error_exception.dart';
import 'package:flutter_application_1/model/class/interest.dart';
import 'package:flutter_application_1/model/class/post_image.dart';
import 'package:flutter_application_1/model/class/post_images.dart';
import 'package:flutter_application_1/model/repository/group_repository.dart';
import 'package:flutter_application_1/model/repository/quest_repository.dart';
import 'package:flutter_application_1/model/repository/user_repository.dart';
import 'package:flutter_application_1/page/common/Status.dart';
import 'package:image_picker/image_picker.dart';

class ExampleQuestViewModel with ChangeNotifier {
  final QuestRepository _questRepository;
  final int questId;
  Status status = Status.loading;
  String description = '';
  late PostImages exampleImages;

  ExampleQuestViewModel({
    required QuestRepository questRepository,
    required this.questId,
  }) : _questRepository = questRepository;

  void load() async {
    try {
      debugPrint('load start: ');
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
}
