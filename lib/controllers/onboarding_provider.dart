import 'package:flutter/material.dart';

class OnBoardNotifier extends ChangeNotifier {
  bool _isLastPage = false;
  bool get isLastPage => _isLastPage;

  set isLastPage(bool value) {
    _isLastPage = value;
    notifyListeners();
  }
}
