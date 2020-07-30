import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sushi_go/dummy_game_driver.dart';
import 'package:sushi_go/providers/client_socket.dart';
import 'package:sushi_go/providers/game_manager.dart';
import 'package:sushi_go/providers/user_provider.dart';
import 'package:sushi_go/router.dart';

void main() {
  // inicializar router y socket
  FluroRouter.initialize();
  ClientSocket();

  // TODO: remove
  DummyGameDriver();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<GameManager>(
          create: (_) => GameManager(),
          lazy: false,
        ),
        Provider<UserProvider>(
          create: (_) => UserProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sushi Go!',
      debugShowCheckedModeBanner: false,

      /// Aca se definen los colores del app.
      theme: ThemeData(
        primarySwatch: Colors.red,
        primaryColor: Colors.red,
        accentColor: Colors.blue,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.red,
        ),
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(
              color: Colors.red,
              width: 3.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(
              width: 2.0,
              color: Colors.grey,
            ),
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      onGenerateRoute: FluroRouter.router.generator,
    );
  }
}
