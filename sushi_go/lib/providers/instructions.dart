import 'package:flutter/material.dart';
import 'package:sushi_go/models/player_model.dart';
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
  int _roomId = 9;
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

}
