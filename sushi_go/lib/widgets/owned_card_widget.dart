import 'package:flutter/material.dart';
import 'package:sushi_go/models/sushi_go_card.dart';

class OwnedCardWidget extends StatelessWidget {
  final SushiGoCard card;

  OwnedCardWidget({this.card});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 200,
        height: 250,
        child: Card(
          color: Colors.redAccent,
          child: Column(
            children: [
              Text(
                card.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: Image.asset('assets/img/${card.img}'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
