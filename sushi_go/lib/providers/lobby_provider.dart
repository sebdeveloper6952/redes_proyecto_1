import 'package:flutter/material.dart';
import 'package:sushi_go/providers/client_socket.dart';

class LobbyProvider extends ChangeNotifier {
  static final LobbyProvider _instance = LobbyProvider._internal();
  bool _loggedIn = false;
  bool _joinedRoom = false;
  int _roomId = -1;
  bool get loggedIn => _loggedIn;
  bool get joinedRoom => _joinedRoom;
  int get roomId => _roomId;

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
  }

  void joinRoom(roomId) {
    ClientSocket().writeToSocket(JoinRoomMessage(roomId: roomId));
  }

  void setJoinedRoom(int roomId) {
    _roomId = roomId;
    _joinedRoom = _roomId > 0 ? true : false;
    notifyListeners();
  }
}

class CreateRoomMessage extends ClientMessage {
  final int type = ClientSocket.CLIENT_CREATE_ROOM;

  @override
  Map<String, dynamic> toJson() {
    return {'type': type};
  }
}

class JoinRoomMessage extends ClientMessage {
  final int type = ClientSocket.SERVER_CREATE_ROOM;
  final int roomId;

  JoinRoomMessage({this.roomId});

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'id': roomId,
    };
  }
}
