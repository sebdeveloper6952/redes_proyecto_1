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
  final _imgMap = {
    1: 'sashimi.png',
    2: 'chopsticks.png',
    3: 'pudding.png',
    4: 'maki_roll.png',
    5: 'maki_roll.png',
    6: 'maki_roll.png',
    7: 'wasabi.png',
    8: 'dumplings.png',
    9: 'tempura.png',
    10: 'salmon_nigiri.png',
    11: 'egg_nigiri.png',
    12: 'squid_nigiri.png'
  };
  final _pointsMap = {
    1: 'x3=10',
    2: 'SWAP FOR 2',
    3: 'MOST 6/LEAST -6',
    4: 'MOST 6/3',
    5: 'MOST 6/3',
    6: 'MOST 6/3',
    7: 'NEXT NIGIRI x3',
    8: '1 3 6 10 15',
    9: 'x2=5',
    10: '2',
    11: '1',
    12: '3',
  };

  List<SushiGoCard> _cards = [];
  final List<SushiGoCard> _ownedCards = [];
  final List<SushiGoCard> _currentlySelectedCards = [];
  int _currentTurn = 1;
  bool _waitingForNextTurn = false;
  bool _playerHasChopsticks = false;
  bool _gameFinished = false;
  List<SushiGoCard> get cards => List.unmodifiable(_cards);
  bool gameStarted = false;
  bool get waitingForNextTurn => _waitingForNextTurn;
  bool get gameFinished => _gameFinished;

  /// constructores
  factory GameManager() {
    return _instance;
  }
  GameManager._internal();

  void setCards(List<dynamic> cardIds) {
    _cards.clear();
    int uid = 0;

    Future future = Future(() {});

    for (int id in cardIds) {
      final card = SushiGoCard(
        id: id,
        uid: uid,
        name: _cardsMap[id],
        points: _pointsMap[id],
        img: _imgMap[id],
      );
      uid++;

      future = future.then((_) {
        return Future.delayed(Duration(milliseconds: 150), () {
          _cards.add(card);
          notifyListeners();
        });
      });
    }

    _waitingForNextTurn = false;
    notifyListeners();
  }

  List<SushiGoCard> getOwnedCards() {
    final List<SushiGoCard> list = List.from(_ownedCards);
    list.sort((i, j) => i.id.compareTo(j.id));

    return list;
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

  bool isCardSelected(SushiGoCard card) {
    return _currentlySelectedCards.contains(card);
  }

  /// Envia cardIds al servidor para dejarle saber que esas fueron
  /// las cartas escogidas para este turno.
  // void chooseCardsForTurn(List<int> cardIds) {
  void chooseCardsForTurn() {
    _waitingForNextTurn = true;

    ClientSocket().writeToSocket(
      SendCardsMessage(
        cards: _currentlySelectedCards.map((c) => c.id).toList(),
      ),
    );

    /// guardar carta(s) seleccionadas para mostrar
    _ownedCards.addAll(_currentlySelectedCards);

    final t = _currentlySelectedCards.map((c) => '${c.id} - ${c.name}');
    for (var i in t) print('sending card: $i');

    /// limpiar lista de cartas seleccionadas
    _currentlySelectedCards.clear();

    notifyListeners();
  }

  void notifyServerReceivedCards() {}

  void setWinners(List<dynamic> winners) {
    winners.forEach((i) {});
    _gameFinished = true;
    notifyListeners();
  }

  void setGameStarted(bool value) {
    if (!gameStarted) {
      gameStarted = value;
      if (!LobbyProvider().playerCreatedRoom)
        ClientSocket().writeToSocket(ClientCardsRequest());
    } else {
      ClientSocket().writeToSocket(ClientCardsRequest());
    }

    notifyListeners();
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
