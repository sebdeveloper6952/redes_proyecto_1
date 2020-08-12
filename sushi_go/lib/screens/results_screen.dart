import 'package:flutter/material.dart';
import 'package:sushi_go/providers/game_manager.dart';
import 'package:provider/provider.dart';
import 'package:sushi_go/providers/lobby_provider.dart';
import 'package:sushi_go/router.dart';

class ResultsScreen extends StatelessWidget {
  final _colors = {
    1: Color.fromRGBO(201, 176, 55, 100),
    2: Color.fromRGBO(215, 215, 215, 100),
    3: Color.fromRGBO(173, 138, 86, 100),
  };

  ResultsScreen({Key key}) : super(key: key);

  Widget _createResultBox(
      EdgeInsetsGeometry m, Color c, String t, String n, String p) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: m,
        width: 200,
        height: 250,
        decoration: BoxDecoration(
          color: c,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Column(
          children: [
            Text(
              t,
            ),
            Expanded(
              child: Center(
                child: Text(
                  n,
                ),
              ),
            ),
            Text(
              p,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final results = context.watch<GameManager>().gameResults;

    final List<Widget> resultsWidget = [];
    resultsWidget.add(
      _createResultBox(
        EdgeInsets.only(bottom: 50, right: 20),
        _colors[2],
        '2do Lugar',
        results[1].name,
        results[1].points.toString(),
      ),
    );
    resultsWidget.add(
      _createResultBox(
        EdgeInsets.only(bottom: 200),
        _colors[1],
        '1er Lugar',
        results[0].name,
        results[0].points.toString(),
      ),
    );
    if (results.length > 2) {
      resultsWidget.add(
        _createResultBox(
          EdgeInsets.only(left: 20),
          _colors[3],
          '3er Lugar',
          results[2].name,
          results[2].points.toString(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        centerTitle: true,
        title: Text('Resultados'),
        actions: [
          FlatButton.icon(
            onPressed: () {
              context.read<LobbyProvider>().returnToLobby();
            },
            icon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            label: Text(
              'Volver al Lobby',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: resultsWidget,
        ),
      ),
    );
  }
}
