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
      child: Container(
        child: Center(
          child: Text(
            card.name,
            style: TextStyle (
              fontSize: 20,
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/img/${card.name}.png"),
          ),
        ),
        height: 130.0,
        width: 130.0,
      ),
    );
  }
}
