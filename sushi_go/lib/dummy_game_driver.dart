import 'dart:math';
import 'package:sushi_go/providers/game_manager.dart';

class DummyGameDriver {
  static final DummyGameDriver _instance = DummyGameDriver._internal();

  DummyGameDriver._internal() {
    _initialize();
  }

  factory DummyGameDriver() {
    return _instance;
  }

  void _initialize() {
    final List<int> ids = [1, 1, 2, 3, 4, 4, 4, 3, 5];
    GameManager().setCards(ids);
  }

  void simulateCardsReceived() {
    final List<int> ids = [];
    final random = Random();

    for (int i = 0; i < random.nextInt(10) + 1; i++)
      ids.add(random.nextInt(12) + 1);

    GameManager().setCards(ids);
  }
}
