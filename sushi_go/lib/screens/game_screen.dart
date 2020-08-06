import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sushi_go/dummy_game_driver.dart';
import 'package:sushi_go/models/sushi_go_card.dart';
import 'package:sushi_go/providers/chat_provider.dart';
import 'package:sushi_go/providers/game_manager.dart';
import 'package:sushi_go/widgets/card_widget.dart';
import 'package:badges/badges.dart';
import 'package:sushi_go/widgets/chat_widget.dart';
import 'package:sushi_go/widgets/loading_card.dart';

class GameScreen extends StatefulWidget {
  GameScreen({Key key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  ChatProvider _chatProvider;
  final List<int> _selectedCards = [0];

  /// Funcion ejecutada al hacer click en cada carta.
  /// Puede cambiar.
  void _onCardClick(SushiGoCard card) {
    _selectedCards.replaceRange(0, 1, [card.id]);
  }

  /// enviar carta(s) seleccionada(s) a servidor
  void _sendCards() {
    DummyGameDriver().sendCards(_selectedCards);
  }

  @override
  void initState() {
    super.initState();
    _chatProvider = context.read<ChatProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cuarto: 123'),
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
      body: Consumer<GameManager>(
        builder: (context, gameManager, child) {
          final loadingWidget = gameManager.waitingForNextTurn
              ? LoadingDialog(
                  title: 'Esperando a los demás...',
                )
              : Container();

          return Stack(
            children: [
              ListView(
                children: gameManager.cards
                    .map(
                      (c) => CardWidget(
                        card: c,
                        onClick: () => _onCardClick(c),
                      ),
                    )
                    .toList(),
              ),
              loadingWidget,
            ],
          );
        },
      ),
    );
  }
}
