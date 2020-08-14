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
    4: 'Maki Roll x3',
    5: 'Maki Roll x2',
    6: 'Maki Roll x1',
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
  final List<PlayerResults> _gameResults = [];
  int _currentTurn = 1;
  bool _waitingForNextTurn = false;
  bool _playerHasChopsticks = false;
  List<SushiGoCard> get cards => List.unmodifiable(_cards);
  bool gameStarted = false;
  bool gameFinished = false;
  bool get waitingForNextTurn => _waitingForNextTurn;
  bool get hasCardSelected => _currentlySelectedCards.length > 0;
  List<PlayerResults> get gameResults => List.unmodifiable(_gameResults);

  /// constructores
  factory GameManager() {
    return _instance;
  }
  GameManager._internal();

  /// Define el maso del jugador para un turno.
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

  /// Retorna true si la carta esta dentro las cartas seleccionadas.
  bool isCardSelected(SushiGoCard card) {
    return _currentlySelectedCards.contains(card);
  }

  /// Envia cardIds al servidor para dejarle saber que esas fueron
  /// las cartas escogidas para este turno.
  // void chooseCardsForTurn(List<int> cardIds) {
  void chooseCardsForTurn() {
    _waitingForNextTurn = true;

    /// ids de cartas seleccionadas que se envian a servidor
    final ids = _currentlySelectedCards.map((c) => c.id).toList();

    /// Los chopsticks se mandan como "-2", y se mandan las otras 2 cartas.
    /// Se remueven los chopsticks de las cartas escogidas por el jugador.
    if (_playerHasChopsticks) {
      ids.add(-2);
      final chopsticksCard = _ownedCards.firstWhere(
        (card) => card.id == 2,
        orElse: () => null,
      );
      if (chopsticksCard != null) _ownedCards.remove(chopsticksCard);
      _playerHasChopsticks = false;
      print('chopsticks se retornaron al maso');
    }

    ClientSocket().writeToSocket(
      SendCardsMessage(cards: ids),
    );

    /// guardar carta(s) seleccionadas para mostrar
    _ownedCards.addAll(_currentlySelectedCards);

    final t = _currentlySelectedCards.map((c) => '${c.id} - ${c.name}');
    for (var i in t) print('sending card: $i');

    /// limpiar lista de cartas seleccionadas
    _currentlySelectedCards.clear();

    notifyListeners();
  }

  /// Accion especial de la carta "Chopsticks"
  void activateChopsticks() {
    print('chopsticks activados');
    _playerHasChopsticks = true;
    notifyListeners();
  }

  void _resetState() {
    _currentTurn = 1;
    _playerHasChopsticks = false;
    _waitingForNextTurn = false;
    gameStarted = false;
    gameFinished = false;
    _ownedCards.clear();
    _currentlySelectedCards.clear();
    notifyListeners();
  }

  void setWinners(List<dynamic> winners) {
    _gameResults.clear();

    winners.forEach((i) {
      _gameResults.add(
        PlayerResults(
          name: i['username'],
          points: i['points'],
        ),
      );
    });
    _gameResults.sort((i, j) {
      return -(i.points.compareTo(j.points));
    });

    _resetState();
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

  void leaveGame() {
    _resetState();
    notifyListeners();
  }

  void notifyPlayerLeftRoom() {
    _resetState();
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

class PlayerResults {
  final String name;
  final int points;

  PlayerResults({
    this.name,
    this.points,
  });
}
