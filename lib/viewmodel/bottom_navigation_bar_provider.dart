import 'package:flutter/material.dart';

class BottomNavigationBarProvider with ChangeNotifier {
  int _currentIndex = 0;
  String _pageName = 'Home';

  int get currentIndex => _currentIndex;
  String get pageName => _pageName;

  set currentIndex(int index) {
    _currentIndex = index;

    switch (index) {
      case 0:
        _pageName = 'Home';
        break;
      case 1:
        _pageName = 'My Programs';
        break;
      default:
    }

    notifyListeners();
  }
}
