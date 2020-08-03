import 'package:sushi_go/providers/client_socket.dart';

class UserProvider {
  static final UserProvider _instance = UserProvider._internal();
  String _username;
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
