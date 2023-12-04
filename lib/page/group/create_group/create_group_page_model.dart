import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/model/class/error_exception.dart';
import 'package:flutter_application_1/model/class/interest.dart';
import 'package:flutter_application_1/model/repository/group_repository.dart';
import 'package:flutter_application_1/model/repository/user_repository.dart';
import 'package:flutter_application_1/page/common/Status.dart';
import 'package:flutter_application_1/provider/error_status_provider.dart';
import 'package:image_picker/image_picker.dart';

class CreateGroupViewModel with ChangeNotifier {
  final ErrorStatusProvider _errorStatusProvider;
  final GroupRepositoty _groupRepositoty;
  final UserRepository _userRepository;

  final PageController controller = PageController();
  List<Interest> interest = [];
  String selectInterest = '';
  String groupName = '';
  bool isDuplicateGroupName = false;
  String groupDescription = '';
  Status status = Status.loading;
  XFile? image;
  final ImagePicker _picker = ImagePicker();

  CreateGroupViewModel({
    required GroupRepositoty groupRepositoty,
    required UserRepository userRepository,
    required errorStatusProvider,
  })  : _groupRepositoty = groupRepositoty,
        _userRepository = userRepository,
        _errorStatusProvider = errorStatusProvider;

  void getInterests() async {
    if (interest.isNotEmpty) {
      return;
    }

    try {
      debugPrint('getInterests start');
      interest = await _userRepository.getRemoteInterest();
      debugPrint('getInterests end');
      notifyListeners();
    } on ErrorException catch (e) {
      _errorStatusProvider.setErrorStatus(true, e.message);
    }
  }

  Future<void> isDuplicatGroupName() async {
    try {
      await _groupRepositoty.getRemoteGroupNameDuplication(groupName);
      isDuplicateGroupName = false;
    } on ErrorException catch (e) {
      debugPrint('${e.message} ');
      if (e.code == 'GRP-01') {
        isDuplicateGroupName = true;
        return;
      }
      _errorStatusProvider.setErrorStatus(true, e.message);
    }
    notifyListeners();
  }

  Future<void> createGroup() async {
    try {
      await _groupRepositoty.createGroup(
          selectInterest, groupName, groupDescription, image!);
      isDuplicateGroupName = false;
    } on ErrorException catch (e) {
      _errorStatusProvider.setErrorStatus(true, e.message);
    } catch (e) {
      debugPrint('createGroup error: ${e.toString} ');
    }
  }

  void setInterest(String input) {
    selectInterest = input;
    notifyListeners();
  }

  void setGroupName(String input) async {
    groupName = input;
    isDuplicatGroupName();
    notifyListeners();
  }

  void setGroupDescription(String input) {
    groupDescription = input;
    notifyListeners();
  }

  //이미지를 가져오는 함수
  Future<void> getImage() async {
    try {
      final XFile? pickedImage = await _picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 500,
        maxWidth: 500,
        imageQuality: 50,
      );

      if (pickedImage != null) {
        //가져온 이미지를 _image에 저장
        image = XFile(pickedImage.path);
      }
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void moveNextPage() {
    controller.nextPage(
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }
}
