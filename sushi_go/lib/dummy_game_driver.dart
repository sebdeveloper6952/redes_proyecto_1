import 'dart:math';
import 'package:sushi_go/providers/chat_provider.dart';
import 'package:sushi_go/providers/game_manager.dart';
import 'package:sushi_go/providers/lobby_provider.dart';
import 'package:sushi_go/providers/user_provider.dart';

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

    Future.delayed(Duration(seconds: 10)).then((value) {
      ChatProvider().messageReceived(1, 'paulb', 'ola amigos');
    });

    Future.delayed(Duration(seconds: 13)).then((value) {
      ChatProvider().messageReceived(2, 'axel', 'que tal estan');
    });

    Future.delayed(Duration(seconds: 17)).then((value) {
      ChatProvider()
          .messageReceived(1, 'paulb', 'ahi listo para unas partidas');
    });
  }

  void simulateCardsReceived() {
    final List<int> ids = [];
    final random = Random();

    for (int i = 0; i < random.nextInt(10) + 1; i++)
      ids.add(random.nextInt(12) + 1);

    GameManager().setCards(ids);
  }

  void login(String username) {
    UserProvider().setUsername(username);
    UserProvider().setUserId(1);
  }

  void createRoom() {
    LobbyProvider().setJoinedRoom(1);
  }

  void joinRoom(int roomId) {
    LobbyProvider().setJoinedRoom(roomId);
  }

  void sendCards(List<int> cardIds) {
    GameManager().chooseCardsForTurn(cardIds);
    Future.delayed(Duration(seconds: 2), () {
      simulateCardsReceived();
    });
  }
}
