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
import 'package:sushi_go/screens/home_screen.dart';

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
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.redAccent,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          top: 16,
                          left: 16,
                        ),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'MIS CARTAS',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
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
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.redAccent,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          top: 16,
                          left: 16,
                        ),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                right: 16,
                              ),
                              child: Text(
                                'TURNO ACTUAL',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            RaisedButton(
                              onPressed: (_gameManager.validCardSelection() &&
                                      !_gameManager.waitingForNextTurn)
                                  ? _sendCards
                                  : null,
                              child: Text(
                                _gameManager.hasChopsticks
                                    ? 'ESCOGER CARTAS'
                                    : 'ESCOGER CARTA',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
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
                ),
              ),
            ],
          ),
          _createLoadingWidget(gameManager.waitingForNextTurn),
        ],
      );
    }

    return Consumer2<GameManager, LobbyProvider>(
      builder: (context, gameManager, lobbyProvider, widget) {
        if (gameManager.gameStarted) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Cuarto: ${_lobbyProvider.roomId}'),
              actions: [
                Consumer<ChatProvider>(
                  builder: (context, chatProvider, widget) {
                    final icon = chatProvider.pendingMessagesCount == 0
                        ? Icon(
                            Icons.chat_bubble_outline,
                            color: Colors.white,
                          )
                        : Badge(
                            badgeColor: Colors.white,
                            badgeContent: Text(
                              chatProvider.pendingMessagesCount.toString(),
                            ),
                            child: Icon(
                              Icons.chat_bubble_outline,
                              color: Colors.white,
                            ),
                          );

                    return FlatButton.icon(
                      label: Text(
                        'Chat',
                        style: TextStyle(color: Colors.white),
                      ),
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
                ),
                FlatButton.icon(
                  label: Text(
                    'Instrucciones',
                    style: TextStyle(color: Colors.white),
                  ),
                  icon: Icon(
                    Icons.help_outline,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SecondRoute()),
                    );
                  },
                ),
                FlatButton.icon(
                  label: Text(
                    'Salir de Cuarto',
                    style: TextStyle(color: Colors.white),
                  ),
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _lobbyProvider.playerExitGame();
                  },
                )
              ],
            ),
            body: _createGameWidget(gameManager),
          );
        } else if (gameManager.gameFinished) {
          return _createResultsWidget(gameManager);
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text('Cuarto: ${_lobbyProvider.roomId}'),
              actions: [
                Consumer<ChatProvider>(
                  builder: (context, chatProvider, widget) {
                    final icon = chatProvider.pendingMessagesCount == 0
                        ? Icon(
                            Icons.chat_bubble_outline,
                            color: Colors.white,
                          )
                        : Badge(
                            badgeColor: Colors.white,
                            badgeContent: Text(
                              chatProvider.pendingMessagesCount.toString(),
                            ),
                            child: Icon(Icons.chat_bubble_outline,
                                color: Colors.white),
                          );

                    return FlatButton.icon(
                      label: Text(
                        'Chat',
                        style: TextStyle(color: Colors.white),
                      ),
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
                ),
                FlatButton.icon(
                  onPressed: () {
                    context.read<LobbyProvider>().playerExitGame();
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
            body: _createWaitingRoomWidget(lobbyProvider),
          );
        }
      },
    );
  }
}
