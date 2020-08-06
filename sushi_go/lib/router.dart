import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:sushi_go/screens/game_screen.dart';
import 'package:sushi_go/screens/home_screen.dart';

class FluroRouter {
  static Router router = Router();

  static Handler _homeScreenHandler = Handler(
    handlerFunc: (BuildContext c, Map<String, dynamic> p) => HomeScreen(),
  );

  static Handler _gameScreenHandler = Handler(
    handlerFunc: (BuildContext c, Map<String, dynamic> p) => GameScreen(),
  );

  /// rutas de la aplicacion y handler para cada ruta
  static void initialize() {
    router.define(
      '/',
      handler: _homeScreenHandler,
      transitionType: TransitionType.inFromBottom,
    );
    router.define(
      '/game',
      handler: _gameScreenHandler,
      transitionType: TransitionType.inFromBottom,
    );
  }
}
