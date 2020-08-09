import 'package:flutter/material.dart';
import 'package:sushi_go/models/sushi_go_card.dart';
import 'package:sushi_go/providers/lobby_provider.dart';
import 'package:sushi_go/providers/user_provider.dart';
import 'client_socket.dart';

class GameManager extends ChangeNotifier {
  /// singleton
  static final GameManager _instance = GameManager._internal();
  final _cardsMap = {
    1: 'Sashimi',
    2: 'Chopsticks',
    3: 'Pudding',
    4: '3x Maki Roll',
    5: '2x Maki Roll',
    6: '1x Maki Roll',
    7: 'Wasabi',
    8: 'Dumplings',
    9: 'Tempura',
    10: 'Salmon Nigiri',
    11: 'Egg Nigiri',
    12: 'Squid Nigiri'
  };

  List<SushiGoCard> _cards = [];
  final List<SushiGoCard> _currentlySelectedCards = [];
  int _currentTurn = 1;
  bool _waitingForNextTurn = false;
  bool _playerHasChopsticks = true;
  List<SushiGoCard> get cards => List.unmodifiable(_cards);
  bool gameStarted = false;
  bool get waitingForNextTurn => _waitingForNextTurn;

  /// constructores
  factory GameManager() {
    return _instance;
  }
  GameManager._internal();

  void setCards(List<dynamic> cardIds) {
    _cards.clear();
    int uid = 0;
    for (int id in cardIds) {
      _cards.add(SushiGoCard(id: id, uid: uid, name: _cardsMap[id]));
      uid++;
    }
    _waitingForNextTurn = false;
    notifyListeners();
  }

  /// Agrega o quita la carta con id cardId a una lista de cartas
  /// seleccionadas.
  bool toggleSelectedCard(SushiGoCard card) {
    final index = _currentlySelectedCards.indexOf(card);
    bool selected = false;

    if (_playerHasChopsticks) {
      if (_currentlySelectedCards.length < 2 && index == -1) {
        _currentlySelectedCards.add(card);
        selected = true;
      } else if (index >= 0) {
        _currentlySelectedCards.removeAt(index);
      }
    } else if (_currentlySelectedCards.length < 1) {
      _currentlySelectedCards.add(card);
      selected = true;
    } else if (index >= 0) {
      _currentlySelectedCards.removeAt(index);
    }

    notifyListeners();

    return selected;
  }

  /// Envia cardIds al servidor para dejarle saber que esas fueron
  /// las cartas escogidas para este turno.
  // void chooseCardsForTurn(List<int> cardIds) {
  void chooseCardsForTurn() {
    _waitingForNextTurn = true;

    /// TODO: remove
    // ClientSocket().writeToSocket(SendCardsMessage(cards: cardIds));

    ClientSocket().writeToSocket(
      SendCardsMessage(
        cards: _currentlySelectedCards.map((c) => c.id).toList(),
      ),
    );

    /// limpiar lista de cartas seleccionadas
    _currentlySelectedCards.clear();

    notifyListeners();
  }

  void notifyServerReceivedCards() {}

  void setWinners(List<dynamic> winners) {
    winners.forEach((i) {});
    notifyListeners();
  }

  void setGameStarted(bool value) {
    if (!gameStarted)
      gameStarted = value;
    else
      _waitingForNextTurn = false;
    notifyListeners();
    ClientSocket().writeToSocket(ClientCardsRequest());
  }
}

class ClientCardsRequest extends ClientMessage {
  final int type = ClientSocket.CLIENT_CARDS_REQUEST;
  final int userId = UserProvider().userId;
  final int roomId = LobbyProvider().roomId;

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'user_id': userId,
      'room_id': roomId,
    };
  }
}

class StartGameMessage extends ClientMessage {
  final id = UserProvider().userId;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': ClientSocket.CLIENT_READY,
    };
  }
}

class SendCardsMessage extends ClientMessage {
  final List<int> cards;

  SendCardsMessage({this.cards}) : super(type: ClientSocket.CLIENT_SEND_CARD);

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'user_id': UserProvider().userId,
      'room_id': LobbyProvider().roomId,
      'cards': cards,
    };
  }
}
