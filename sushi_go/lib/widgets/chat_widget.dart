import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sushi_go/providers/user_provider.dart';

class ChatWidget extends StatefulWidget {
  ChatWidget({Key key}) : super(key: key);

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
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
          Container(
            height: size.height / 1.5,
            width: size.width / 2,
            child: ListView(
              children: [
                ChatMessage(
                  user: 'PaulBelches',
                  message: 'Me escupen las putas!',
                ),
                ChatMessage(
                  user: 'AxelTrujillo',
                  message: 'AJAJAJAJAJA',
                ),
                ChatMessage(
                  user: 'Sebas',
                  message: 'Ola!!!',
                ),
              ],
            ),
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
                  child: TextField(),
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
                  onPressed: () {},
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
  final String user;
  final String message;

  ChatMessage({
    this.user,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final username = Provider.of<UserProvider>(context).username;

    return Align(
      alignment:
          user == username ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: MediaQuery.of(context).size.width / 3,
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: user == username ? Colors.red[300] : Colors.blue[300],
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user,
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            Text(
              message,
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
