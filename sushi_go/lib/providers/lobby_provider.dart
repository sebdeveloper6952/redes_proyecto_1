import 'package:flutter/material.dart';
import 'package:sushi_go/models/player_model.dart';
import 'package:sushi_go/providers/chat_provider.dart';
import 'package:sushi_go/providers/client_socket.dart';
import 'package:sushi_go/providers/game_manager.dart';
import 'package:sushi_go/providers/user_provider.dart';

class LobbyProvider extends ChangeNotifier {
  static final LobbyProvider _instance = LobbyProvider._internal();

  /// TODO: remove dummy players
  final List<PlayerModel> _roomPlayers = [];
  bool _loggedIn = false;
  bool _joinedRoom = false;
  bool _playerCreatedRoom = false;
  int _roomId = -1;
  bool get loggedIn => _loggedIn;
  bool get joinedRoom => _joinedRoom;
  bool get playerCreatedRoom => _playerCreatedRoom;
  int get roomId => _roomId;
  int get playerCount => _roomPlayers.length;
  List<PlayerModel> get players => List.unmodifiable(_roomPlayers);

  LobbyProvider._internal();
  factory LobbyProvider() {
    return _instance;
  }

  void setLoggedIn() {
    _loggedIn = true;
    notifyListeners();
  }

  void createRoom() {
    ClientSocket().writeToSocket(CreateRoomMessage());
    _playerCreatedRoom = true;
    _roomPlayers.add(
      PlayerModel(
        id: UserProvider().userId,
        username: UserProvider().username,
      ),
    );
    notifyListeners();
  }

  void joinRoom(int roomId) {
    ClientSocket().writeToSocket(JoinRoomMessage(roomId: roomId));
  }

  void setJoinedRoom(int roomId) {
    _roomId = roomId;
    _joinedRoom = _roomId >= 0 ? true : false;
    notifyListeners();
  }

  void setRoomPlayers(List<dynamic> players) {
    _roomPlayers.clear();
    _roomPlayers.addAll(players.map((p) => PlayerModel.fromJson(p)).toList());
    notifyListeners();
  }

  void startGame() {
    ClientSocket().writeToSocket(StartGameMessage());
    GameManager().setGameStarted(true);
  }

  void returnToLobby() {
    _roomPlayers.clear();
    _joinedRoom = false;
    _playerCreatedRoom = false;
    _roomId = -1;
    GameManager().gameStarted = false;
    GameManager().gameFinished = false;
    ChatProvider().resetMessages();
    notifyListeners();
  }

  void playerExitGame() {
    _joinedRoom = false;
    _playerCreatedRoom = false;
    _roomPlayers.clear();
    GameManager().leaveGame();
    ChatProvider().resetMessages();
    ClientSocket().writeToSocket(LeaveGameMessage());
    _roomId = -1;
    notifyListeners();
  }

  void playerExitApp() {
    notifyListeners();
    ClientSocket().writeToSocket(LeaveAppMessage());
  }

  void notifyPlayerLeftRoom() {
    _joinedRoom = false;
    _playerCreatedRoom = false;
    _roomId = -1;
    notifyListeners();
  }
}

class CreateRoomMessage extends ClientMessage {
  final int type = ClientSocket.CLIENT_CREATE_ROOM;

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'user_id': UserProvider().userId,
    };
  }
}

class JoinRoomMessage extends ClientMessage {
  final int type = ClientSocket.CLIENT_JOIN_ROOM;
  final int roomId;

  JoinRoomMessage({this.roomId});

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'user_id': UserProvider().userId,
      'room_id': roomId,
    };
  }
}

class StartGameMessage extends ClientMessage {
  final int type = ClientSocket.CLIENT_READY;
  final int roomId = LobbyProvider().roomId;

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'room_id': roomId,
    };
  }
}

class LeaveGameMessage extends ClientMessage {
  final int type = ClientSocket.CLIENT_LEAVE_GAME;
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

class LeaveAppMessage extends ClientMessage {
  final int type = ClientSocket.CLIENT_LEAVE_APP;
  final int userId = UserProvider().userId;

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'user_id': userId,
    };
  }
}
