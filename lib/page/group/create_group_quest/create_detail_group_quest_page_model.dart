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

  // 제목이 15자를 넘으면 안된다.
  bool isOverLength = false;
  String questContent = '';
  String expiredAt = '';
  String selectInterest = '';
  int selectLabelIndex = -1;
  String selectLabel = '';
  List<Interest> interest = [];
  bool isLoad = false;
  List<String> labelList = [];
  final PageController controller = PageController();

  CreateDetailGroupQuestViewModel({
    required GroupRepositoty groupRepositoty,
    required UserRepository userRepository,
    required this.questId,
  })  : _groupRepositoty = groupRepositoty,
        _userRepository = userRepository;

  void getLabelList() async {
    if (questId == -1) {
      return;
    }

    String url = '${API_BASE_URL}/group/$questId/quest/labels';
    debugPrint('getLabelList start:');

    try {
      var sseClient = SSEClient.subscribeToSSE(
        method: SSERequestType.GET,
        url: url,
        header: {'Authorization': 'UserId 1'},
      );

      await for (var event in sseClient) {
        handleSSEEvent(event);
      }
    } catch (e) {
      debugPrint('SSE error: $e');
    }

    debugPrint('getLabelList end');
  }

  void handleSSEEvent(SSEModel event) {
    if (event.data != null) {
      debugPrint('event.id: ${event.id}');
      debugPrint('event.event: ${event.event}');
      debugPrint('event.data: ${event.data}');

      if (event.event == 'labels' && event.data!.startsWith('{')) {
        debugPrint('event.data 뚫었는지 확인: ${event.data}');
        try {
          Map<String, dynamic> jsonData = json.decode(event.data!);
          labelList = List<String>.from(jsonData['labels'] ?? []);
          debugPrint('labelList: ${labelList}');
          notifyListeners();
        } catch (e) {
          // Handle JSON decoding error
          debugPrint('JSON decoding error: $e');
        }
      }
    }
  }

  void getInterests() async {
    if (interest.isNotEmpty || isLoad) {
      debugPrint('getInterests 차단!');
      return;
    }

    try {
      debugPrint('getInterests start');
      isLoad = true;
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

  void validateTitleOverLength() {
    isOverLength = false;

    if (15 < questTitle.length) {
      isOverLength = true;
    }

    notifyListeners();
    return;
  }

  void setQuestTitle(String input) {
    questTitle = input;
    validateTitleOverLength();
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
