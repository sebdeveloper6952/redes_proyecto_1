import 'package:flutter/material.dart';
import 'package:sushi_go/models/sushi_go_card.dart';

class GameManager extends ChangeNotifier {
  final _cardsMap = {
    1: SushiGoCard(id: 1, name: 'Sashimi'),
    2: SushiGoCard(id: 2, name: 'Chopsticks'),
    3: SushiGoCard(id: 3, name: 'Pudding'),
    4: SushiGoCard(id: 4, name: '3x Maki Roll'),
    5: SushiGoCard(id: 5, name: '2x Maki Roll'),
    6: SushiGoCard(id: 6, name: '1x Maki Roll'),
    7: SushiGoCard(id: 7, name: 'Wasabi'),
    8: SushiGoCard(id: 8, name: 'Dumplings'),
    9: SushiGoCard(id: 9, name: 'Tempura'),
    10: SushiGoCard(id: 10, name: 'Salmon Nigiri'),
    11: SushiGoCard(id: 11, name: 'Egg Nigiri'),
    12: SushiGoCard(id: 12, name: 'Squid Nigiri')
  };

  // singleton
  static final GameManager _instance = GameManager._internal();
  factory GameManager() {
    return _instance;
  }
  GameManager._internal();

  List<SushiGoCard> _cards = [];
  List<SushiGoCard> get cards => List.unmodifiable(_cards);

  void setCards(List<int> cardIds) {
    _cards.clear();
    for (int id in cardIds) _cards.add(_cardsMap[id]);
    notifyListeners();
  }
}
