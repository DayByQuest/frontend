import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/class/error_exception.dart';
import 'package:flutter_application_1/provider/error_status_provider.dart';

import '../../../model/repository/user_repository.dart';
import '../../common/Status.dart';

class AccountDisclosureViewModel with ChangeNotifier {
  final ErrorStatusProvider _errorStatusProvider;
  final UserRepository _userRepository;

  AccountDisclosureViewModel(
      {required UserRepository userRepository, required errorStatusProvider})
      : _userRepository = userRepository,
        _errorStatusProvider = errorStatusProvider;

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
    } on ErrorException catch (e) {
      _errorStatusProvider.setErrorStatus(true, e.message);
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
    } on ErrorException catch (e) {
      _errorStatusProvider.setErrorStatus(true, e.message);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
