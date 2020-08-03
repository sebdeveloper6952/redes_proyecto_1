import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sushi_go/providers/user_provider.dart';
import 'package:sushi_go/router.dart';
import 'package:sushi_go/widgets/single_string_dialog.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _username;

  void _createRoom() async {
    print('Create room');

    // Ejemplo de como navegar.
    FluroRouter.router.navigateTo(context, '/game');
  }

  void _joinRoom() async {
    final roomId = await showDialog<String>(
      context: context,
      builder: (_) => SingleStringDialog(
        title: 'Unirse a cuarto.',
        content: 'Ingresa el ID del cuarto.',
      ),
    );
    print('Join room $roomId');
  }

  void _submitUsername() {
    if (_username == null || _username.length < 4) return;
    Provider.of<UserProvider>(context, listen: false).setUsername(_username);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final _usernameWidget = Container(
      width: size.width / 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Hola! Ingresa tu nombre:'),
          Container(
            margin: const EdgeInsets.only(
              top: 8,
            ),
            child: TextField(
              onChanged: (val) {
                _username = val;
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 8,
            ),
            height: 48,
            width: size.width / 2,
            child: RaisedButton(
              child: Text(
                'INGRESAR',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () => _submitUsername(),
            ),
          ),
        ],
      ),
    );

    final _lobbyWidget = Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            child: RaisedButton(
              onPressed: () => _createRoom(),
              child: Text(
                'CREAR CUARTO',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Container(
            width: 200,
            child: RaisedButton(
              onPressed: () => _joinRoom(),
              child: Text(
                'UNIRSE A CUARTO',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Lobby'),
      ),
      body: Center(
        child: _username == null ? _usernameWidget : _lobbyWidget,
      ),
    );
  }
}
