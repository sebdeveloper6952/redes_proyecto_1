import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';

import 'package:sushi_go/models/sushi_go_card.dart';
import 'package:sushi_go/providers/chat_provider.dart';
import 'package:sushi_go/providers/game_manager.dart';

class ClientSocket {
  static const int CLIENT_LOGIN = 101;
  static const int SERVER_LOGIN_RES = 102;
  static const int CLIENT_LOGIN_ACK = 103;
  static const int CLIENT_CREATE_ROOM = 104;
  static const int SERVER_CREATE_ROOM = 105;
  static const int CLIENT_JOIN_ROOM = 106;
  static const int SERVER_JOIN_ROOM = 107;
  static const int CLIENT_READY = 108;
  static const int SERVER_CLIENT_READY_ACK = 109;
  static const int CLIENT_CARDS_REQUEST = 110;
  static const int SERVER_CARDS_RESPONSE = 111;
  static const int CLIENT_SEND_CARD = 112;
  static const int SERVER_GAME_FINISH = 114;
  static const int CLIENT_SEND_CHAT_MESSAGE = 200;
  static const int CLIENT_RECV_CHAT_MESSAGE = 201;
  Socket _socket;

  // singleton and constructor
  static final ClientSocket _instance = ClientSocket._internal();

  factory ClientSocket() {
    return _instance;
  }

  ClientSocket._internal();

  void initialize() {
    print('Client: trying to connect to server...');
    Socket.connect('127.0.0.1', 9876).then((socket) {
      /// Guardar referencia a socket.
      _socket = socket;

      print(
          'Client: connected to: ${socket.remoteAddress.address}:${socket.remotePort}');

      /// definir callbacks para los eventos onData, onDone, onError.
      socket.listen(_socketOnData,
          onDone: _socketOnDone, onError: _socketOnError);
    }).catchError((Object error) {
      print('Client: error connecting to server.');
    });
  }

  /// TODO: implement
  void _retryConnection() {}

  /// Todos los mensajes exitosos se reciben en este metodo.
  void _socketOnData(Uint8List data) {
    final String stringMessage = String.fromCharCodes(data).trim();
    final messageJsonMap = json.decode(stringMessage);
    final ServerMessage serverMessage = ServerMessage.fromJson(messageJsonMap);

    if (serverMessage.type == SERVER_LOGIN_RES) {
      // server login response
    } else if (serverMessage.type == SERVER_CREATE_ROOM) {
      // server create room response
    } else if (serverMessage.type == SERVER_JOIN_ROOM) {
      // server join room response
    } else if (serverMessage.type == SERVER_CARDS_RESPONSE) {
      // server cards response
      final List<int> cardIds = messageJsonMap['cards'];

      // check for error
      if (cardIds == null) {}

      // list of cards
      GameManager().setCards(cardIds);
    } else if (serverMessage.type == SERVER_GAME_FINISH) {
      // server game finish response
    } else if (serverMessage.type == CLIENT_RECV_CHAT_MESSAGE) {
      // client received chat message
      final message = messageJsonMap['message'] ?? '';
      final user_id = messageJsonMap['user_id'] ?? -1;
      final username = messageJsonMap['username'] ?? '';
      ChatProvider().messageReceived(user_id, username, message);
    }
  }

  void _socketOnDone() {
    _socket.destroy();
    print('Client: server closed connection.');
  }

  void _socketOnError(Object error) {}

  void writeToSocket(ClientMessage message) {
    final Map<String, dynamic> jsonMessage = message.toJson();
    final String stringMessage = json.encode(jsonMessage);
    _socket?.write(stringMessage);
  }
}

class ServerMessage {
  final int type;
  ServerMessage({this.type});
  factory ServerMessage.fromJson(Map<String, dynamic> json) {
    return ServerMessage(type: json['type'] ?? -1);
  }
}

abstract class ClientMessage {
  final int type;
  ClientMessage({this.type});
  Map<String, dynamic> toJson();
}
