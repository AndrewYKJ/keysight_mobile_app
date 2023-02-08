import 'package:flutter/material.dart';

class Counter extends ChangeNotifier {
  var _count = 0;

  int get getCounter {
    return _count;
  }

  void setCount(int count) {
    _count = count;
    notifyListeners();
  }
}
