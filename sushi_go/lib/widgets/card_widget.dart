import 'package:flutter/material.dart';
import 'package:sushi_go/models/sushi_go_card.dart';

class CardWidget extends StatelessWidget {
  final SushiGoCard card;

  const CardWidget({
    Key key,
    this.card,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: Text(
          card.name,
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ),
    );
  }
}
