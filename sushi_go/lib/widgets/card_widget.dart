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
        child: GestureDetector(
          onTap: () {
            if (_gameManager.waitingForNextTurn) return;
            _selected = _gameManager.toggleSelectedCard(widget.card);
            _elevation = _selected ? 8.0 : 1.0;
            setState(() {});
          },
          child: MouseRegion(
            onEnter: (event) {
              setState(() {
                _elevation = 8.0;
              });
            },
            onExit: (event) {
              if (_selected) return;
              setState(() {
                _elevation = 1.0;
              });
            },
            child: Card(
              elevation: _elevation,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              color: _selected ? Colors.greenAccent : Colors.redAccent,
              child: Column(
                children: [
                  Expanded(
                    child: Image.asset('assets/img/${widget.card.img}'),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(9),
                        bottomRight: Radius.circular(9),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          widget.card.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Dessert',
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.card.points,
                          style: TextStyle(
                            fontFamily: 'Dessert',
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
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
