import 'package:flutter/material.dart';
import 'package:sushi_go/models/sushi_go_card.dart';
import 'package:sushi_go/providers/game_manager.dart';
import 'package:provider/provider.dart';

class OwnedCardWidget extends StatefulWidget {
  final SushiGoCard card;

  OwnedCardWidget({this.card});

  @override
  _OwnedCardWidgetState createState() => _OwnedCardWidgetState();
}

class _OwnedCardWidgetState extends State<OwnedCardWidget> {
  GameManager _gameManager;

  @override
  void initState() {
    super.initState();
    _gameManager = context.read<GameManager>();
  }

  @override
  Widget build(BuildContext context) {
    final actionWidget = widget.card.id == 2
        ? Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 8),
              child: RaisedButton(
                hoverColor: Colors.greenAccent,
                color: Colors.redAccent.withOpacity(0.15),
                child:
                    Text(_gameManager.hasChopsticks ? 'DESACTIVAR' : 'ACTIVAR'),
                onPressed: () {
                  _gameManager.toggleChopsticks();
                },
              ),
            ),
          )
        : Container();

    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 200,
        height: 250,
        child: Card(
          color: Colors.redAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            children: [
              Expanded(
                child: Stack(children: [
                  Center(child: Image.asset('assets/img/${widget.card.img}')),
                  actionWidget,
                ]),
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
    );
  }
}
