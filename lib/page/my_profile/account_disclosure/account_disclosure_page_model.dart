import 'package:flutter/material.dart';

import '../../../model/repository/user_repository.dart';
import '../../common/Status.dart';

class AccountDisclosureViewModel with ChangeNotifier {
  final UserRepository _userRepository;

  AccountDisclosureViewModel({required UserRepository userRepository})
      : _userRepository = userRepository;

  Status _status = Status.loading;
  late bool _isPrivate;

  bool get isPrivate => _isPrivate;
  Status get status => _status;

  void load() async {
    try {
      debugPrint('load start');
      _isPrivate = await _userRepository.getRemoteVisibility();
      _status = Status.loaded;
      notifyListeners();
      debugPrint('load end');
    } catch (e) {
      debugPrint('load error: ${e.toString()}');
    }
  }

  void changeVisibility(bool isVisibility) async {
    try {
      _status = Status.loading;
      await _userRepository.patchRemoteVisibility(isVisibility);
      _isPrivate = !_isPrivate;
      _status = Status.loaded;
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
