import 'package:flutter/material.dart';
import 'package:sushi_go/models/sushi_go_card.dart';
import 'package:sushi_go/providers/game_manager.dart';
import 'package:provider/provider.dart';

class OwnedCardWidget extends StatelessWidget {
  final SushiGoCard card;

  OwnedCardWidget({this.card});

  @override
  Widget build(BuildContext context) {
    final actionWidget = card.id == 2
        ? Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 8),
              child: RaisedButton(
                hoverColor: Colors.greenAccent,
                color: Colors.redAccent.withOpacity(0.15),
                child: Text('ACTIVAR'),
                onPressed: () {
                  context.read<GameManager>().activateChopsticks();
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
                  Center(child: Image.asset('assets/img/${card.img}')),
                  actionWidget,
                ]),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(9),
                    bottomRight: Radius.circular(9),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      card.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(card.points),
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
