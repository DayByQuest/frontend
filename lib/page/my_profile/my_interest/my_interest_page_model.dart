import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/class/error_exception.dart';
import 'package:flutter_application_1/model/class/interest.dart';
import 'package:flutter_application_1/provider/error_status_provider.dart';

import '../../../model/repository/user_repository.dart';
import '../../common/Status.dart';

class MyInterestViewModel with ChangeNotifier {
  final ErrorStatusProvider _errorStatusProvider;
  final UserRepository _userRepository;

  MyInterestViewModel(
      {required UserRepository userRepository, required errorStatusProvider})
      : _userRepository = userRepository,
        _errorStatusProvider = errorStatusProvider;

  Status _status = Status.loading;
  List<Interest> _interest = [];
  final Set<String> _selectedInterest = {};

  Status get status => _status;
  List<Interest> get interest => _interest;
  Set<String> get selectedInterest => _selectedInterest;

  void load() async {
    try {
      if (_interest.isNotEmpty) {
        return;
      }

      debugPrint('load start');
      _interest = await _userRepository.getRemoteInterest();
      _status = Status.loaded;
      notifyListeners();
      debugPrint('load end');
    } on ErrorException catch (e) {
      _errorStatusProvider.setErrorStatus(true, e.message);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> changeInterest() async {
    try {
      if (_selectedInterest.isEmpty) {
        throw Exception('관심사 선택을 안함');
      }

      List<String> interestList = _selectedInterest.toList();
      debugPrint('changeInterest start ${interestList.toList()}');
      _status = Status.loading;
      notifyListeners();
      await _userRepository.patchRemoteInterest(interestList);
      _status = Status.loaded;
      notifyListeners();
      debugPrint('changeInterest end');
    } on ErrorException catch (e) {
      _errorStatusProvider.setErrorStatus(true, e.message);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void addInterest(String interestItem) {
    selectedInterest.add(interestItem);
    notifyListeners();
  }

  void removeIntrest(String interestItem) {
    selectedInterest.remove(interestItem);
    notifyListeners();
  }
}
