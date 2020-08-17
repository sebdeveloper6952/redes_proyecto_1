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
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _lobbyProvider = context.watch<LobbyProvider>();

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
      body: Stack(
        children: [
          _lobbyProvider.hasError
              ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  color: Colors.grey[850],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _lobbyProvider.errorMsg,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 32),
                        child: IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            _lobbyProvider.dismissError();
                          },
                        ),
                      )
                    ],
                  ),
                )
              : Container(),
          Center(
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
                          MaterialPageRoute(
                              builder: (context) => SecondRoute()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          '¿Como jugar?',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Center(
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Text(
                  'El juego se desarrolla mientras haya cartas disponibles.' +
                      'Cuando un round comienza todos los jugadores deben elegir' +
                      '1 carta de la baraja que les tocó, la carta seleccionada' +
                      'permanecerá con el jugador escondida, cuando todos los' +
                      'jugadores hayan tomado su decisión se continuará el juego' +
                      '(si no te gusta lo elegiste vuelve a presionar la carta' +
                      'elegida para elegir otra pero hazlo antes de guardar), el' +
                      'resto de la baraja volverán a ser repartidas y el siguiente' +
                      'round vas a recibir una nueva baraja. Ahora recuerda que' +
                      'debes elegir tus cartas con sabiduría porque si quieres ganar' +
                      'en este juego deberás hacer más puntos que los demás, ¿pero' +
                      'cómo hago más puntos que los demás? La forma de sumar punto es' +
                      'realizando combinaciones exitosas con las cartas que vamos' +
                      'eligiendo, esas combinaciones son las siguientes: ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 23,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            Container(
              child: ListTile(
                leading: Icon(Icons.card_giftcard),
                title: Text(
                  'Tempura: ',
                  style: TextStyle(
                    fontSize: 23,
                  ),
                ),
                subtitle: Text(
                  ' - Una pareja de tempuras son 5 puntos, una tempura solitaria' +
                      'no vale nada pero marcar más de una pareja en un round. ',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Container(
              child: ListTile(
                leading: Icon(Icons.card_giftcard),
                title: Text(
                  'Sashimi: ',
                  style: TextStyle(
                    fontSize: 23,
                  ),
                ),
                subtitle: Text(
                  ' - Un trío de sashimis son 10 puntos, un sashimi solo o incluso' +
                      'dos no valen nada, puedes marcar más de un trío de Sashimi en un ' +
                      'solo round pero te lo advierto es difícil. ',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Container(
              child: ListTile(
                leading: Icon(Icons.card_giftcard),
                title: Text(
                  'Dumplings: ',
                  style: TextStyle(
                    fontSize: 23,
                  ),
                ),
                subtitle: Text(
                  ' - Un dumpling equivale a 1 punto, dos dumplings equivalen a 3 puntos,' +
                      'tres dumplings equivalen a 6 puntos, 4 dumplings equivalen a 10 puntos y' +
                      'por último 5 dumplings equivalen a 15 puntos. ',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Container(
              child: ListTile(
                leading: Icon(Icons.card_giftcard),
                title: Text(
                  'Nigiri y Wasabi: ',
                  style: TextStyle(
                    fontSize: 23,
                  ),
                ),
                subtitle: Text(
                  ' - Un nigiri de calamar equivale a 3 puntos pero junto con un wasabi equivale' +
                      'a 9 puntos, el nigiri de salmón solo equivale a 2 puntos pero junto a un wasabi' +
                      'equivale a 6 puntos , y un nigiri de huevo solo equivale un punto pero junto al' +
                      'wasabi equivale a 3. El wasabi no vale nada.',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Container(
              child: ListTile(
                leading: Icon(Icons.card_giftcard),
                title: Text(
                  'Chopsticks: ',
                  style: TextStyle(
                    fontSize: 23,
                  ),
                ),
                subtitle: Text(
                  ' - El chopstick no vale nada. ',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment(0, 8),
              child: Container(
                child: RaisedButton(
                  color: Colors.purple,
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
          ],
        ),
      ),
    );
  }
}
