# UVG - Redes - Proyecto 1 BSD Sockets
## Juego de Cartas
Integrantes
- Alexander Trujillo
- Paul Belches
- Sebastián Arriola

### Juego Elegido: SushiGo
- De 2 a 5 jugadores.
- Es un juego inspirado en los restaurantes japoneses en los cuales la comida pasa por una banda rotatoria, y las personas van agarrando los platillos que deseen. SushiGo toma ese concepto y lo plasma en un divertido juego de cartas en el cual los jugadores deben formar combinaciones de platillos para obtener puntos y vencer a sus oponentes. Es un juego con reglas muy sencillas, de duración corta, pero que sin duda entretiene.
- Video demo de grupo: https://youtu.be/vkR9rx3SxZc
- Video de explicación de reglas (ver a partir de minuto 18:45): https://youtu.be/Xu9RB-N4T3g?t=1120

### Principales Dificultades
- Una de las principales dificultades, fue desarrollar la representación correcta de la información dentro del sistema. De manera que esta fuera fácil de manejar, y entender.
- Además fue un reto ir delimitando las acciones que tenían que tener una solicitud asociadas a ellas. En lugar de algo que solo se encargará el sistema.
- ya que para algunos mientros del grupo la tacnologia de flutter era nueva, mientras se realizaba el proyecto se tubo que aprender a usar tambien. 
### Lecciones Aprendidas
- Cuando se desarrolla una aplicación en la cual existe comunicación entre varias instancias de dicha aplicación, es de suma importancia definir de antemano el protocolo con el cual se comunicarán dichas instancias. Esto asegura que todas las partes saben que "idioma" hablar para que las demás partes los comprendan.
- El protocolo de comunicación debe ser abstracto, alejado de cualquier detalle de implementación y únicamente definir el "idioma" que se hablará en una aplicación.
- Se implemento el uso de un multiplexor en el proyecto, por lo que entender su funcionalidad.  
- La logica que se tiene que seguir para poder crear una aplicacion multijugador online. 

# Instalación y Ejecución
- Nota: a continuación se detallan las reglas para ejecutar el proyecto local.
- Se debe ejecutar primero el servidor.
- Luego, se pueden crear varias ventanas del cliente, al menos 2, para poder iniciar un juego.
- Si se desea ejecutar en la nube, por favor contactarnos y pondremos a correr el servidor en la nube.
#### Servidor
- python >= 3.6.9
- numpy >= 1.19.1
- ejecutar:
```bash
cd server
python server.py
```

#### Front End
- flutter >= 1.21.0
- dependencias varían por sistema operativo, visitar: https://flutter.dev/docs/get-started/install para ver el proceso detallado de instalación.
- ejecutar (en linux):
```bash
cd sushi_go
flutter build linux
cd build/linux/release/bundle
./sushi_go
```
# Protocolo
- Se utilizaron sockets BSD del lado del servidor y del lado del cliente.
- se basa en transmisión de mensajes en formato JSON
- a continuación se detallan todos los mensajes del protocolo
#### Mensaje 101
- flujo: Cliente a Servidor.
- descripción: Actúa como un login.
```json
{
  "type": 101,
  "username": "juanito"
}
```
#### Mensaje 102
- flujo: Servidor a Cliente.
- descripción: ACK de mensaje 101, deja saber al cliente que su login fue exitoso.
```json
{
  "type": 102,
  "user_id": 1234
}
```
#### Mensaje 402
- flujo: Servidor a Cliente.
- descripción: Se envía para indicar que hubo un error en el login.
```json
{
  "type": 402
}
```
#### Mensaje 104
- flujo: Cliente a Servidor.
- descripción: Solicitud para crear un cuarto de juego.
```json
{
  "type": 104,
  "user_id": 1234
}
```

#### Mensaje 105
- flujo: Servidor a Cliente.
- descripción: ACK de mensaje 104, se retorna el id del nuevo cuarto en caso exitoso, o -1 si ocurrió un error.
```json
{
  "type": 105,
  "room_id": 1234
}
```
#### Mensaje 405
- flujo: Servidor a Cliente.
- descripción: Se envía para indicar que hubo un error al crear un cuarto.
```json
{
  "type": 405,
}
```

#### Mensaje 106
- flujo: Cliente a Servidor.
- descripción: Solicitud para unirse a un cuarto de juego.
```json
{
  "type": 106,
  "user_id": 1234,
  "room_id": 1234
}
```

#### Mensaje 107
- flujo: Servidor a Cliente.
- descripción: ACK de mensaje 106, se retorna el id del cuarto para unirse, o -1 si ocurrió un error.
```json
{
  "type": 107,
  "user_id": 1234
}
```

#### Mensaje 407
- flujo: Servidor a Cliente.
- descripción: Se envía para indicar que hubo un error al unirse al cuarto.
```json
{
  "type": 407
}
```

#### Mensaje 108
- flujo: Cliente a Servidor.
- descripción: Solicitud para iniciar un el juego, únicamente lo puede realizar el jugador que creó el cuarto de juego.
```json
{
  "type": 108,
  "room_id": 1234
}
```

#### Mensaje 109
- flujo: Servidor a Cliente.
- descripción: Se envía a todos los jugadores del cuarto, "status" es 1 si el juego se pudo iniciar, o 0 de lo contrario.
```json
{
  "type": 109,
  "status": 1
}
```

#### Mensaje 409
- flujo: Servidor a Cliente.
- descripción: Se envía para indicar que hubo un error al iniciar el juego.
```json
{
  "type": 409
}
```

#### Mensaje 110
- flujo: Cliente a Servidor.
- descripción: Jugador lo envía para recibir un mazo de cartas.
```json
{
  "type": 110,
  "user_id": 1234,
  "room_id": 1234
}
```

#### Mensaje 111
- flujo: Servidor a Cliente.
- descripción: Se envía mazo de cartas al jugador.
```json
{
  "type": 111,
  "cards": [1, 2, 2, 1, 4]
}
```

#### Mensaje 112
- flujo: Cliente a Servidor.
- descripción: Jugador envía la(s) carta(s) que quiere seleccionar en un turno.
```json
{
  "type": 112,
  "user_id": 1234,
  "room_id": 1234,
  "cards": [1]
}
```

#### Mensaje 412
- flujo: Servidor a Cliente.
- descripción: Se envía para indicar que hubo un error al recibir cartas de un jugador.
```json
{
  "type": 412
}
```

#### Mensaje 114
- flujo: Servidor a Cliente.
- descripción: Se envía a todos los jugadores de un cuarto para indicar que el juego ha terminado.
```json
{
  "type": 114,
  "status": [
    {
      "id": 1234,
      "username": "axel",
      "points": 100
    },
    {
      "id": 1235,
      "username": "sebas",
      "points": 86
    },
    {
      "id": 1236,
      "username": "paul",
      "points": 90
    },
  ]
}
```

#### Mensaje 414
- flujo: Servidor a Cliente.
- descripción: Se envía a todos los jugadores de un cuarto para indicar que hubo un error en el cálculo de puntos.
```json
{
  "type": 414
}
```

#### Mensaje 115
- flujo: Servidor a Cliente.
- descripción: Se envía a todos los jugadores de un cuarto para indicar que un nuevo jugador se ha unido al cuarto.
```json
{
  "type": 115,
  "players": [
    {"id": 1234, "username": "sebas"},
    {"id": 1235, "username": "paul"}
  ]
}
```
#### Mensaje 200
- flujo: Cliente a Servidor.
- descripción: Cliente envía mensaje de chat.
```json
{
  "type": 200,
  "user_id": 1234,
  "room_id": 1234,
  "message": "ola!"
}
```

#### Mensaje 500
- flujo: Servidor a Cliente.
- descripción: Se envía para indicar que hubo un error al envíar un mensaje.
```json
{
  "type": 500
}
```

#### Mensaje 201
- flujo: Servidor a Cliente.
- descripción: Servidor realiza un broadcast del mensaje de chat recibido a todos los jugadores del mismo cuarto.
```json
{
  "type": 201,
  "user_id": 1234,
  "username": "sebas",
  "message": "ola!"
}
```
#### Mensaje 202
- flujo: Cliente a Servidor.
- descripción: El jugador sale de su cuarto de juego.
```json
{
  "type": 202,
  "user_id": 1234,
  "room_id": 1234
}
```
#### Mensaje 203
- flujo: Servidor a Cliente.
- descripción: Servidor les indica a los demás jugadores del cuarto que otro jugador se salió del cuarto.
```json
{
  "type": 203
}
```

#### Mensaje 503
- flujo: Servidor a Cliente.
- descripción: Se envía para indicar que hubo un error al salir de un cuarto.
```json
{
  "type": 503
}
```

#### Mensaje 204
- flujo: Cliente a Servidor.
- descripción: El jugador sale de la aplicación, el servidor elimina todo registro de dicho jugador.
```json
{
  "type": 204,
  "user_id": 1234
}
```
#### Mensaje 504
- flujo: Servidor a Cliente.
- descripción: Se envía para indicar que hubo un error en la salida de un jugador.
```json
{
  "type": 504
}
```
