import 'package:flutter/material.dart';
import 'package:sushi_go/models/sushi_go_card.dart';
import 'client_socket.dart';

class GameManager extends ChangeNotifier {
  /// singleton
  static final GameManager _instance = GameManager._internal();
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

  List<SushiGoCard> _cards = [];
  List<SushiGoCard> get cards => List.unmodifiable(_cards);
  int _currentTurn = 1;
  bool _waitingForNextTurn = false;
  bool get waitingForNextTurn => _waitingForNextTurn;

  /// constructores
  factory GameManager() {
    return _instance;
  }
  GameManager._internal();

  void setCards(List<int> cardIds) {
    _cards.clear();
    for (int id in cardIds) _cards.add(_cardsMap[id]);
    _waitingForNextTurn = false;
    notifyListeners();
  }

  /// Envia cardIds al servidor para dejarle saber que esas fueron
  /// las cartas escogidas para este turno.
  void chooseCardsForTurn(List<int> cardIds) {
    _waitingForNextTurn = true;
    ClientSocket().writeToSocket(SendCardsMessage(cards: cardIds));
    notifyListeners();
  }

  void notifyServerReceivedCards() {}

  void setWinners(List<dynamic> winners) {
    winners.forEach((i) {});
    notifyListeners();
  }
}

class SendCardsMessage extends ClientMessage {
  final List<int> cards;

  SendCardsMessage({this.cards}) : super(type: ClientSocket.CLIENT_SEND_CARD);

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'cards': cards,
    };
  }
}
