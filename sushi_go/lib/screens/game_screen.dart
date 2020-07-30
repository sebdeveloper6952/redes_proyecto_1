import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sushi_go/dummy_game_driver.dart';
import 'package:sushi_go/providers/game_manager.dart';
import 'package:sushi_go/widgets/card_widget.dart';
import 'package:badges/badges.dart';
import 'package:sushi_go/widgets/chat_widget.dart';

class GameScreen extends StatefulWidget {
  GameScreen({Key key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.autorenew),
            onPressed: () {
              DummyGameDriver().simulateCardsReceived();
            },
          ),
          IconButton(
            icon: Badge(
              badgeColor: Colors.white,
              badgeContent: Text('1'),
              child: Icon(Icons.chat_bubble_outline),
            ),
            onPressed: () {
              // mostrar dialogo/widget de chat
              showDialog(
                context: context,
                builder: (_) => ChatWidget(),
              );
            },
          )
        ],
      ),
      body: Consumer<GameManager>(
        builder: (context, gameManager, child) {
          return ListView(
            children: gameManager.cards
                .map(
                  (c) => CardWidget(card: c),
                )
                .toList(),
          );
        },
      ),
    );
  }
}
