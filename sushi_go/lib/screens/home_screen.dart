import 'package:flutter/material.dart';
import 'package:sushi_go/router.dart';
import 'package:sushi_go/widgets/single_string_dialog.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lobby'),
      ),
      body: Center(
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
      ),
    );
  }
}
