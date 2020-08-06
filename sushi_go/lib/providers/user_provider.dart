import 'package:flutter/material.dart';
import 'package:sushi_go/providers/client_socket.dart';

class UserProvider extends ChangeNotifier {
  static final UserProvider _instance = UserProvider._internal();
  int _userId;
  String _username;
  int get userId => _userId;
  String get username => _username;

  UserProvider._internal();
  factory UserProvider() {
    return _instance;
  }

  void setUsername(String username) {
    _username = username;
    final clientMessage = LoginMessage(username: _username);
    ClientSocket().writeToSocket(clientMessage);
  }

  void setUserId(int userId) {
    _userId = userId;
    notifyListeners();
  }
}

class LoginMessage extends ClientMessage {
  final String username;

  LoginMessage({this.username});

  Map<String, dynamic> toJson() {
    return {
      "type": ClientSocket.CLIENT_LOGIN,
      "username": username,
    };
  }
}

class LoginResponse extends ServerMessage {
  final int id;

  LoginResponse({this.id}) : super(type: ClientSocket.SERVER_LOGIN_RES);
}
