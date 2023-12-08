import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/class/error_exception.dart';
import 'package:flutter_application_1/provider/error_status_provider.dart';
import 'package:image_picker/image_picker.dart';

import '../../../model/repository/user_repository.dart';
import '../../common/Status.dart';

class ProfileImageEditViewModel with ChangeNotifier {
  final ErrorStatusProvider _errorStatusProvider;
  final UserRepository _userRepository;

  ProfileImageEditViewModel(
      {required UserRepository userRepository, required errorStatusProvider})
      : _userRepository = userRepository,
        _errorStatusProvider = errorStatusProvider;

  Status _status = Status.loading;
  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  late String _currentImageUrl;

  Status get status => _status;
  XFile? get image => _image;
  String get currentImageUrl => _currentImageUrl;

  void load(String imageUrl) {
    try {
      debugPrint(imageUrl);
      _currentImageUrl = imageUrl;
      _status = Status.loaded;
      notifyListeners();
    } on ErrorException catch (e) {
      _errorStatusProvider.setErrorStatus(true, e.message);
    } catch (e) {
      debugPrint(e.toString());
    }
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
        _image = XFile(pickedImage.path);
      }
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> changeProfileImage() async {
    try {
      if (_image != null) {
        _status = Status.loading;
        notifyListeners();
        await _userRepository.patchRemoteProfileImage(_image!);
        _status = Status.loaded;
        notifyListeners();
      }
      return;
    } on ErrorException catch (e) {
      _errorStatusProvider.setErrorStatus(true, e.message);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
