import 'package:flutter/material.dart';

class AlertBottomBarProvider extends ChangeNotifier {
  bool showBottom;
  bool selectAll;
  AlertBottomBarProvider({this.showBottom = false, this.selectAll = false});

  void changeBtmState(bool newState) {
    showBottom = newState;
    notifyListeners();
  }

  void selectAllItem(bool newState) {
    selectAll = newState;
    notifyListeners();
  }
}
