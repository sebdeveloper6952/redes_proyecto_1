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

void main() {
  runApp(MaterialApp(
    title: 'Navigation Basics',
    home: FirstRoute(),
  ));
}

class _HomeScreenState extends State<HomeScreen> {
  UserProvider _userProvider;
  LobbyProvider _lobbyProvider;
  String _username;

  void _createRoom() async {
    print('Create room');

    /// mandar mensaje para crear cuarto
    _lobbyProvider.createRoom();
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

    /// mandar mensaje para unirse a cuarto
    _lobbyProvider.joinRoom(int.parse(roomId));
  }

  void _submitUsername() {
    if (_username == null || _username.length < 4) return;

    /// mandar mensaje de login
    _userProvider.setUsername(_username);
  }

  @override
  void initState() {
    super.initState();
    _userProvider = context.read<UserProvider>();
    _lobbyProvider = context.read<LobbyProvider>();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final usernameWidget = Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Container(
          width: size.width / 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Image.asset('assets/img/logo.png'),
              ),
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
                  child: _lobbyProvider.loggedIn
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
                  onPressed:
                      _lobbyProvider.loggedIn ? null : () => _submitUsername(),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final lobbyWidget = Scaffold(
      appBar: AppBar(
        title: Text('Lobby'),
        actions: [
          FlatButton.icon(
            onPressed: () {
              _lobbyProvider.playerExitApp();
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            label: Text(
              'Salir',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Image.asset('assets/img/logo.png'),
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 8.0,
                ),
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
              Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 8.0,
                ),
                width: 200,
                child: RaisedButton(
                  child: Text(
                    'INSTRUCCIONES',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SecondRoute()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return Consumer<LobbyProvider>(
      builder: (c, lobbyProvider, w) {
        if (lobbyProvider.joinedRoom) {
          return GameScreen();
        } else if (lobbyProvider.loggedIn) {
          return lobbyWidget;
        } else {
          return usernameWidget;
        }
      },
    );
  }
}

class FirstRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 200,
          child: RaisedButton(
            child: Text(
              'INSTRUCCIONES',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SecondRoute()),
              );
            },
          ),
        ),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment(0, 8),
        child: Container(
          margin: const EdgeInsets.symmetric(
            vertical: 300.0,
          ),
          child: RaisedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'REGRESAR',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
