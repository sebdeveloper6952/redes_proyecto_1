import 'package:flutter/material.dart';
import 'package:sushi_go/models/player_model.dart';

class LobbyPlayerWidget extends StatelessWidget {
  final PlayerModel player;

  const LobbyPlayerWidget({Key key, this.player}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).accentColor,
      child: ListTile(
        leading: Icon(Icons.person_pin),
        title: Text('${player.id} - ${player.username}'),
      ),
    );
  }
}
