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
        child: Text(
          card.name,
          textAlign: TextAlign.center,
          style: TextStyle (
            fontSize: 25,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: Colors.red,
          ),
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
