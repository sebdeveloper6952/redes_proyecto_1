import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sushi_go/providers/chat_provider.dart';
import 'package:sushi_go/providers/game_manager.dart';
import 'package:sushi_go/providers/lobby_provider.dart';
import 'package:sushi_go/screens/results_screen.dart';
import 'package:sushi_go/widgets/card_widget.dart';
import 'package:badges/badges.dart';
import 'package:sushi_go/widgets/chat_widget.dart';
import 'package:sushi_go/widgets/loading_card.dart';
import 'package:sushi_go/widgets/lobby_player_widget.dart';
import 'package:sushi_go/widgets/owned_card_widget.dart';

class GameScreen extends StatefulWidget {
  GameScreen({Key key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  GameManager _gameManager;
  LobbyProvider _lobbyProvider;
  ChatProvider _chatProvider;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  final List<Widget> _listItems = [];

  /// enviar carta(s) seleccionada(s) a servidor
  void _sendCards() {
    GameManager().chooseCardsForTurn();
  }

  @override
  void initState() {
    super.initState();
    _gameManager = context.read<GameManager>();
    _lobbyProvider = context.read<LobbyProvider>();
    _chatProvider = context.read<ChatProvider>();
  }

  Widget _createResultsWidget(GameManager gameManager) {
    return ResultsScreen();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    _createWaitingRoomWidget(LobbyProvider lobby) {
      final startGameBtn = lobby.playerCreatedRoom
          ? Container(
              margin: const EdgeInsets.symmetric(
                vertical: 16,
              ),
              width: size.width / 2,
              child: RaisedButton(
                onPressed:
                    lobby.playerCount > 1 ? () => lobby.startGame() : null,
                child: Text(
                  'INICIAR PARTIDA',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            )
          : Container(
              margin: const EdgeInsets.symmetric(
                vertical: 16,
              ),
              child: Text('Esperando que inicie la partida...'),
            );

      return Center(
        child: Container(
          width: size.width / 2,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: lobby.players
                      .map((p) => LobbyPlayerWidget(player: p))
                      .toList(),
                ),
              ),
              startGameBtn,
            ],
          ),
        ),
      );
    }

    _createLoadingWidget(bool waiting) {
      return waiting
          ? LoadingDialog(
              title: 'Esperando a los demás...',
            )
          : Container();
    }

    _createGameWidget(GameManager gameManager) {
      return Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/img/background1.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: gameManager
                      .getOwnedCards()
                      .map(
                        (c) => OwnedCardWidget(card: c),
                      )
                      .toList(),
                ),
              ),
              Expanded(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: gameManager.cards
                      .map(
                        (c) => CardWidget(card: c),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
          _createLoadingWidget(gameManager.waitingForNextTurn),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Cuarto: ${_lobbyProvider.roomId}'),
        actions: [
          IconButton(
            icon: Icon(Icons.autorenew),
            onPressed: () => _sendCards(),
          ),
          Consumer<ChatProvider>(
            builder: (context, chatProvider, widget) {
              final icon = chatProvider.pendingMessagesCount == 0
                  ? Icon(Icons.chat_bubble_outline)
                  : Badge(
                      badgeColor: Colors.white,
                      badgeContent: Text(
                        chatProvider.pendingMessagesCount.toString(),
                      ),
                      child: Icon(Icons.chat_bubble_outline),
                    );

              return IconButton(
                icon: icon,
                onPressed: () {
                  _chatProvider.resetMessagesPendingCount();
                  showDialog(
                    context: context,
                    builder: (_) => ChatWidget(),
                  );
                },
              );
            },
          )
        ],
      ),
      body: Consumer2<GameManager, LobbyProvider>(
        builder: (context, gameManager, lobbyProvider, widget) {
          if (gameManager.gameStarted) {
            return _createGameWidget(gameManager);
          } else if (gameManager.gameFinished) {
            return _createResultsWidget(gameManager);
          } else {
            return _createWaitingRoomWidget(lobbyProvider);
          }
        },
      ),
    );
  }
}
