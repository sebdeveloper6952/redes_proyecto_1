import 'package:flutter/material.dart';
import 'package:sushi_go/models/sushi_go_card.dart';

class CardWidget extends StatelessWidget {
  final SushiGoCard card;
  final Function onClick;

  const CardWidget({
    Key key,
    this.card,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onClick(),
      child: Card(
        color: Colors.redAccent,
        child: Center(
          child: Text(
            card.name,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
      ),
    );
  }
}
