# sushi_go

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

EXPERIENCIA: 
se decidio usar fluter ya que es una tecnologia que nos permite crear aplicaciones maleables, por lo que el desarrollo de la jugabilidad y de los objetos que se usan durante el juego fue algo que se pudo manegar de la manera que pensabamos aparte la combinacion flutter python ya era previamente conocida por lo que no se tuvo muchas difcicultades en ese aspecto, eso nos permitio desarrollar el protocolo de conexion como lo pensabamos y con exito. Por otro lado ya con el juego terminado se hicieron diversas pruebas con personas ajenas al trabajo para encontrar posibles errores y gracias eso se encontraron varios errores que se parchearon permitiendonos tener un mejor trabajo. 

INSTRUCCIONES: 
El juego se desarrolla mientras haya cartas disponibles. Cuando un round comienza todos los jugadores deben elegir 1 carta de la baraja que les tocó, la carta seleccionada permanecerá con el jugador escondida, cuando todos los jugadores hayan tomado su decisión se continuará el juego (si no te gusta lo elegiste vuelve a presionar la carta elegida para elegir otra pero hazlo antes de guardar), el resto de la baraja volverán a ser repartidas y el siguiente round vas a recibir una nueva baraja. Ahora recuerda que debes elegir tus cartas con sabiduría porque si quieres ganar en este juego deberás hacer más puntos que los demás, ¿pero cómo hago más puntos que los demás? La forma de sumar punto es realizando combinaciones exitosas con las cartas que vamos eligiendo, esas combinaciones son las siguientes: 
Tempura: 
Una pareja de tempuras son 5 puntos, una tempura solitaria no vale nada pero marcar más de una pareja en un round. 
Sashimi:
Un trío de sashimis son 10 puntos, un sashimi solo o incluso dos no valen nada, puedes marcar más de un trío de Sashimi en un solo round pero te lo advierto es difícil. 
Dumplings:
Un dumpling equivale a 1 punto, dos dumplings equivalen a 3 puntos, tres dumplings equivalen a 6 puntos, 4 dumplings equivalen a 10 puntos y por último 5 dumplings equivalen a 15 puntos. 
Nigiri y Wasabi:
Un nigiri de calamar equivale a 3 puntos pero junto con un wasabi equivale a 9 puntos, el nigiri de salmón solo equivale a 2 puntos pero junto a un wasabi equivale a 6 puntos , y un nigiri de huevo solo equivale un punto pero junto al wasabi equivale a 3. El wasabi no vale nada.
Chopsticks: 
El chopstick no vale nada. 

COMO CORRER: 
abrir una terminal en la carpeta "server" buscar el archivo server.py y correr el siguiente comando:
    python3 server.py 

abrir una segunda terminar dentro de la carpeta "sushi_go" y correr el siguiente comando:
    flutter run -d linux 

Si se desea solo jugar de una forma mas rapida saltarse los dos pasos anteriores abrir un bundle y iniciar el programa sushi_go. 
