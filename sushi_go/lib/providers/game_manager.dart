import 'package:flutter/material.dart';

class GameManager extends ChangeNotifier {
  GameManager() {}

  void setCards() {
    notifyListeners();
  }
}
