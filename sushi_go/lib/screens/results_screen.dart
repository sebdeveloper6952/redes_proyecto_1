import 'package:flutter/material.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
        fontFamily: 'Sushi', fontSize: 32, fontWeight: FontWeight.bold);

    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        centerTitle: true,
        title: Text('Resultados'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.only(
                  bottom: 50,
                  right: 20,
                ),
                width: 200,
                height: 250,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(215, 215, 215, 100),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      '2do Lugar',
                      style: textStyle,
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Juan',
                          style: textStyle,
                        ),
                      ),
                    ),
                    Text(
                      '15 puntos',
                      style: textStyle,
                    )
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.only(
                  bottom: 200,
                ),
                width: 200,
                height: 250,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(201, 176, 55, 100),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.only(
                  left: 20,
                ),
                width: 200,
                height: 250,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(173, 138, 86, 100),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
