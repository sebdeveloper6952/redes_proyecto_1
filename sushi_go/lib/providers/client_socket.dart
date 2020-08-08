import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:sushi_go/providers/chat_provider.dart';
import 'package:sushi_go/providers/game_manager.dart';
import 'package:sushi_go/providers/lobby_provider.dart';
import 'package:sushi_go/providers/user_provider.dart';

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
  static const int SERVER_CARDS_RECEIVED = 113;
  static const int SERVER_GAME_FINISH = 114;
  static const int SERVER_PLAYER_JOINED_ROOM = 115;
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
    Socket.connect('127.0.0.1', 65432).then((socket) {
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
    final String stringMessage =
        String.fromCharCodes(data).replaceAll('\'', '"').trim();

    /// TODO: remove
    print('Received: $stringMessage');
    final messageJsonMap = json.decode(stringMessage);
    final ServerMessage serverMessage = ServerMessage.fromJson(messageJsonMap);

    if (serverMessage.type == SERVER_LOGIN_RES) {
      // userId indica si login fue exitoso
      final userId = messageJsonMap['id'] ?? -1;
      UserProvider().setUserId(userId);
      LobbyProvider().setLoggedIn();
    } else if (serverMessage.type == SERVER_CREATE_ROOM) {
      // roomId indica si fue posible crear un cuarto
      final roomId = messageJsonMap['id'] ?? -1;
      LobbyProvider().setJoinedRoom(roomId);
    } else if (serverMessage.type == SERVER_JOIN_ROOM) {
      // status indica el jugador se pudo unir al cuarto
      final roomId = messageJsonMap['idCuarto'] ?? -1;
      LobbyProvider().setJoinedRoom(roomId);
    } else if (serverMessage.type == SERVER_CARDS_RESPONSE) {
      final List<int> cardIds = messageJsonMap['cards'] ?? [];
      // algun error jeje
      if (cardIds == null) {}
      // notificar a game manager que se recibieron nuevas cartas
      GameManager().setCards(cardIds);
    } else if (serverMessage.type == SERVER_CARDS_RECEIVED) {
      /// notificar a game manager de que cartas fueron recibidas.
      GameManager().notifyServerReceivedCards();
    } else if (serverMessage.type == SERVER_GAME_FINISH) {
      // server responde que juego ha terminado
      final List<dynamic> gameStatus = messageJsonMap['status'] ?? [];
      // notificar a game manager de los puntajes
      GameManager().setWinners(gameStatus);
    } else if (serverMessage.type == SERVER_PLAYER_JOINED_ROOM) {
      final playersMap = messageJsonMap['players'] ?? [];
      LobbyProvider().setRoomPlayers(playersMap);
    } else if (serverMessage.type == CLIENT_RECV_CHAT_MESSAGE) {
      // mensaje de chat recibido
      final message = messageJsonMap['message'] ?? '';
      final userId = messageJsonMap['User_id'] ?? -1;
      final username = messageJsonMap['Username'] ?? '';
      ChatProvider().messageReceived(userId, username, message);
    }
  }

  void _socketOnDone() {
    _socket.destroy();
    print('Client: server closed connection.');
  }

  void _socketOnError(Object error) {}

  void writeToSocket(ClientMessage message) {
    print('writing to socket message type: ${message.type}');
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
