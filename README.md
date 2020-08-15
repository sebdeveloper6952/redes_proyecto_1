# UVG - Redes - Proyecto 1
## Juego de Cartas
Integrantes
- Alexander Trujillo
- Paul Belches
- Sebastián Arriola

### Juego Elegido: SushiGo

# Instalación
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
- descripción: Se envía mazo de cartas a jugador.
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
- descripción: Jugador se sale de su cuarto de juego.
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
#### Mensaje 204
- flujo: Cliente a Servidor.
- descripción: Jugador se sale de la aplicación, el servidor elimina todo registro de dicho jugador.
```json
{
  "type": 204,
  "user_id": 1234
}
```
