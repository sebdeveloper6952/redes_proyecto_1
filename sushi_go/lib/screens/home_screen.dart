import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sushi_go/dummy_game_driver.dart';
import 'package:sushi_go/providers/lobby_provider.dart';
import 'package:sushi_go/providers/user_provider.dart';
import 'package:sushi_go/router.dart';
import 'package:sushi_go/screens/game_screen.dart';
import 'package:sushi_go/widgets/single_string_dialog.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserProvider _userProvider;
  LobbyProvider _lobbyProvider;
  String _username;
  bool _loading = false;

  void _createRoom() async {
    print('Create room');

    // TODO: remove
    DummyGameDriver().createRoom();
    // _lobbyProvider.createRoom();

    // Ejemplo de como navegar.
    // FluroRouter.router.navigateTo(context, '/game');
  }

  void _joinRoom() async {
    final roomId = await showDialog<String>(
      context: context,
      builder: (_) => SingleStringDialog(
        title: 'Unirse a cuarto.',
        content: 'Ingresa el ID del cuarto.',
      ),
    );
    if (roomId == null) return;

    // TODO: remove
    DummyGameDriver().joinRoom(int.parse(roomId));
    // _lobbyProvider.joinRoom(roomId);

    print('Join room $roomId');
  }

  void _submitUsername() {
    if (_username == null || _username.length < 4) return;
    _userProvider.setUsername(_username);
    // TODO: remove
    DummyGameDriver().login(_username);
    setState(() {
      _loading = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _lobbyProvider = Provider.of<LobbyProvider>(context, listen: false);
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
              child: _loading
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.red,
                      ),
                    )
                  : Text(
                      'INGRESAR',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
              onPressed: _loading ? null : () => _submitUsername(),
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

    final lobbyWidget = Scaffold(
      appBar: AppBar(
        title: Text('Lobby'),
      ),
      body: Center(
        child: _userProvider.userId == null ? _usernameWidget : _lobbyWidget,
      ),
    );

    return Consumer<LobbyProvider>(
      builder: (c, lobbyProvider, w) {
        if (lobbyProvider.joinedRoom) {
          return GameScreen();
        }
        return lobbyWidget;
      },
    );
  }
}
