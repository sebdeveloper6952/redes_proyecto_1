import 'package:flutter/material.dart';
import 'package:sushi_go/models/sushi_go_card.dart';
import 'package:sushi_go/providers/game_manager.dart';
import 'package:provider/provider.dart';

class CardWidget extends StatefulWidget {
  final SushiGoCard card;

  const CardWidget({
    Key key,
    this.card,
  }) : super(key: key);

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  GameManager _gameManager;
  Color _bgColor = Colors.redAccent;
  double _elevation = 1.0;

  @override
  void initState() {
    super.initState();
    _gameManager = context.read<GameManager>();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final bool selected = _gameManager.toggleSelectedCard(widget.card);

        /// TODO: definir aca estado de carta seleccionada / no seleccionada
        setState(() {
          _bgColor = selected ? Colors.greenAccent : Colors.redAccent;
          _elevation = selected ? 4.0 : 1.0;
        });
      },
      child: Card(
        elevation: _elevation,
        color: _bgColor,
        child: Center(
          child: Text(
            widget.card.name,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
      ),
    );
  }
}
