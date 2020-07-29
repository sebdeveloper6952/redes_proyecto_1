import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sushi_go/providers/dummy_socket.dart';
import 'package:sushi_go/router.dart';

void main() {
  // inicializar router
  FluroRouter.initialize();

  runApp(MultiProvider(
    providers: [
      Provider<DummySocket>(
        create: (_) => DummySocket(),
        lazy: false,
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sushi Go!',

      /// Aca se definen los colores del app.
      theme: ThemeData(
        primarySwatch: Colors.red,
        primaryColor: Colors.red,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.red,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      onGenerateRoute: FluroRouter.router.generator,
    );
  }
}
