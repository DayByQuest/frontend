import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/model/class/interest.dart';
import 'package:flutter_application_1/model/repository/group_repository.dart';
import 'package:flutter_application_1/model/repository/user_repository.dart';
import 'package:flutter_application_1/page/common/Status.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CreateDetailGroupQuestViewModel with ChangeNotifier {
  final GroupRepositoty _groupRepositoty;
  final UserRepository _userRepository;

  String API_BASE_URL = dotenv.env['API_BASE_URL'] ?? '';
  final int questId;
  Status status = Status.loading;

  String questTitle = '';
  String questContent = '';
  String expiredAt = '';
  String selectInterest = '';
  int selectLabelIndex = -1;
  String selectLabel = '';
  List<Interest> interest = [];
  List<String> labelList = [];
  final PageController controller = PageController();

  CreateDetailGroupQuestViewModel({
    required GroupRepositoty groupRepositoty,
    required UserRepository userRepository,
    required this.questId,
  })  : _groupRepositoty = groupRepositoty,
        _userRepository = userRepository;

  void testFunc() {
    if (questId == -1) {
      return;
    }

    String url = '${API_BASE_URL}/group/$questId/quest/labels';
    debugPrint('testFunc start:');
    status = Status.loaded;
    notifyListeners();
    SSEClient.subscribeToSSE(method: SSERequestType.GET, url: url, header: {
      'Authorization': 'UserId 1',
    }).listen(
      (event) {
        if (event.data != null) {
          if (event.data != 'success') {
            debugPrint('event.data:${event.data}');
            Map<String, dynamic> jsonData = json.decode(event.data!);
            labelList = List<String>.from(jsonData['labels'] ?? []);
            debugPrint('labelList: ${labelList}');
            status = Status.loaded;
            notifyListeners();
          }
        }

        debugPrint('eventevent: ' + event.toString());
        debugPrint('DataData: ${event?.data}');
      },
    );
    debugPrint('testFunc end');
  }

  void getInterests() async {
    if (interest.isNotEmpty) {
      return;
    }

    try {
      debugPrint('getInterests start');
      interest = await _userRepository.getRemoteInterest();
      debugPrint('getInterests end');
      notifyListeners();
    } on Exception catch (e) {
      debugPrint('getInterests error: ${e.toString()}');
    }
  }

  bool hasLabel() {
    if (selectLabel.isEmpty) {
      return false;
    }

    return true;
  }

  Future<void> createGroupQuestDetail() async {
    if (!hasLabel()) {
      return;
    }

    try {
      debugPrint(
          "createGroupQuestDetail start: ${questTitle}, ${questContent},${expiredAt}, ${selectInterest}, ${selectLabel}, ${questId}}");
      await _groupRepositoty.createGroupQuestDetail(questTitle, questContent,
          expiredAt, selectInterest, selectLabel, questId);
    } catch (e) {
      debugPrint("createGroupQuestDetail error: ${e.toString()}");
    }
  }

  void setInterest(String input) {
    selectInterest = input;
    notifyListeners();
  }

  void setQuestTitle(String input) {
    questTitle = input;
    notifyListeners();
  }

  void setQuestContent(String input) {
    questContent = input;
    notifyListeners();
  }

  void setLabelIndex(bool isChecked, int targerIndex) {
    if (isChecked) {
      selectLabelIndex = -1;
      selectLabel = '';
      notifyListeners();
      return;
    }

    selectLabelIndex = targerIndex;
    selectLabel = labelList[targerIndex];
    notifyListeners();
    return;
  }

  void setLabel(String input) {
    selectLabel = input;
    notifyListeners();
    return;
  }

  String twoDigits(int n) {
    if (n >= 10) {
      return "$n";
    }
    return "0$n";
  }

  void setExpiredAt(DateTime input) {
    String formattedDate =
        "${input.year}-${twoDigits(input.month)}-${twoDigits(input.day)} 23:55";
    expiredAt = formattedDate;
    notifyListeners();
  }

  void moveNextPage() {
    controller.nextPage(
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }
}
