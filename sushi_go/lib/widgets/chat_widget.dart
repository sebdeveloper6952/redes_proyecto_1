import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sushi_go/providers/chat_provider.dart';
import 'package:sushi_go/providers/client_socket.dart';
import 'package:sushi_go/providers/user_provider.dart';

class ChatWidget extends StatefulWidget {
  ChatWidget({Key key}) : super(key: key);

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final _textFieldController = TextEditingController();
  String _message;

  void _sendMessage() async {
    if (_message == null) return;
    Provider.of<ChatProvider>(context, listen: false).sendMessage(_message);
    _textFieldController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height / 1.5,
      width: size.width / 2,
      child: SimpleDialog(
        titlePadding: const EdgeInsets.all(0),
        contentPadding: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        title: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
          ),
          child: Text(
            'Chat',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        children: [
          Consumer<ChatProvider>(
            builder: (context, chatProvider, widget) {
              return Container(
                height: size.height / 1.5,
                width: size.width / 2,
                child: ListView(
                  children: chatProvider.messages
                      .map((m) => ChatMessage(message: m))
                      .toList(),
                ),
              );
            },
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(
                    bottom: 8,
                    left: 16,
                  ),
                  child: TextField(
                    controller: _textFieldController,
                    onChanged: (val) {
                      _message = val;
                    },
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  right: 16,
                  bottom: 16,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.send,
                    color: Theme.of(context).primaryColor,
                    size: 35,
                  ),
                  onPressed: () => _sendMessage(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final ChatMessageModel message;

  ChatMessage({
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final username = Provider.of<UserProvider>(context, listen: false).username;

    return Align(
      alignment: message.username == username
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        width: MediaQuery.of(context).size.width / 3,
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              message.username == username ? Colors.red[300] : Colors.blue[300],
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.username,
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            Text(
              message.message,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
