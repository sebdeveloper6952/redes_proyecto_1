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
  bool _selected;
  double _elevation = 1.0;
  double _marginBottom = 0.0;

  @override
  void initState() {
    super.initState();
    _gameManager = context.read<GameManager>();
  }

  @override
  Widget build(BuildContext context) {
    _selected = _gameManager.isCardSelected(widget.card);
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 200,
        height: 250,
        margin: EdgeInsets.only(bottom: _marginBottom),
        child: GestureDetector(
          onTap: () {
            _selected = _gameManager.toggleSelectedCard(widget.card);
            _elevation = _selected ? 8.0 : 1.0;
            setState(() {});
          },
          child: MouseRegion(
            onEnter: (event) {
              setState(() {
                _elevation = 8.0;
                _marginBottom = 50.0;
              });
            },
            onExit: (event) {
              if (_selected) return;
              setState(() {
                _elevation = 1.0;
                _marginBottom = 0;
              });
            },
            child: Card(
              elevation: _elevation,
              color: _selected ? Colors.greenAccent : Colors.redAccent,
              child: Column(
                children: [
                  Text(
                    widget.card.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Image.asset('assets/img/${widget.card.img}'),
                  ),
                ],
              ),
            ),
          ),
        ),
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
