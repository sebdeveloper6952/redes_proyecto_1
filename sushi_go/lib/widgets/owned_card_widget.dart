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
          child: Center(
            child: Text(
              card.name,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
        ),
      ),
    );
  }
}
