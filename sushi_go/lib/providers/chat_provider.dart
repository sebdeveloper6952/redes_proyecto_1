import 'package:flutter/material.dart';
import 'package:sushi_go/providers/client_socket.dart';
import 'package:sushi_go/providers/lobby_provider.dart';
import 'package:sushi_go/providers/user_provider.dart';

class ChatProvider extends ChangeNotifier {
  static final ChatProvider _instance = ChatProvider._internal();
  final List<ChatMessageModel> _messages = [];
  int _pendingMessages = 0;

  List<ChatMessageModel> get messages => List.unmodifiable(_messages);
  int get pendingMessagesCount => _pendingMessages;

  ChatProvider._internal();

  factory ChatProvider() {
    return _instance;
  }

  void sendMessage(String message) async {
    if (message == null || message.length == 0) return;

    final userProvider = UserProvider();
    _messages.add(
      ChatMessageModel(
          userId: userProvider.userId,
          username: userProvider.username,
          message: message),
    );
    notifyListeners();
    ClientSocket().writeToSocket(
      _SocketSendChatMessage(message: message),
    );
  }

  /// Agrega mensaje a lista de mensajes recibidos y notifica a observadores.
  void messageReceived(int userId, String username, String message) {
    _messages.add(
      ChatMessageModel(
        userId: userId,
        username: username,
        message: message,
      ),
    );
    _pendingMessages++;
    notifyListeners();
  }

  void resetMessagesPendingCount() {
    _pendingMessages = 0;
    notifyListeners();
  }
}

class ChatMessageModel {
  final int userId;
  final String username;
  final String message;

  ChatMessageModel({
    this.userId,
    this.username,
    this.message,
  });
}

class _SocketSendChatMessage extends ClientMessage {
  final int type = ClientSocket.CLIENT_SEND_CHAT_MESSAGE;
  final String message;

  _SocketSendChatMessage({this.message});

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'user_id': UserProvider().userId,
      'room_id': LobbyProvider().roomId,
      'message': message,
    };
  }
}
