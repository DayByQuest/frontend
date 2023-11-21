import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/class/interest.dart';

import '../../../model/repository/user_repository.dart';
import '../../common/Status.dart';

class MyInterestViewModel with ChangeNotifier {
  final UserRepository _userRepository;

  MyInterestViewModel({required UserRepository userRepository})
      : _userRepository = userRepository;

  Status _status = Status.loading;
  List<Interest> _interest = [];
  final Set<String> _selectedInterest = {};

  Status get status => _status;
  List<Interest> get interest => _interest;
  Set<String> get selectedInterest => _selectedInterest;

  void load() async {
    try {
      _interest = await _userRepository.getRemoteInterest();
      _status = Status.loaded;
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> changeInterest() async {
    try {
      if (_selectedInterest.isEmpty) {
        throw Exception('관심사 선택을 안함');
      }

      _status = Status.loading;
      notifyListeners();
      await _userRepository.patchRemoteInterest(_selectedInterest.toList());
      _status = Status.loaded;
      notifyListeners();
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
