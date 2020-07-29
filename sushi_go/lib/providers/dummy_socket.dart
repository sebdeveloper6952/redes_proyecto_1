import 'dart:io';
import 'dart:typed_data';

class DummySocket {
  Socket _socket;

  DummySocket() {
    print('Trying to connect to server...');
    Socket.connect('127.0.0.1', 9876).then((socket) {
      /// Guardar referencia a socket.
      _socket = socket;

      print(
          'Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');

      /// definir callbacks para los eventos onData, onDone, onError.
      socket.listen(_socketOnData,
          onDone: _socketOnDone, onError: _socketOnError);
    }).catchError((Object error) {
      print('Error connecting to server.');
    });
  }

  /// Todos los mensajes exitosos se reciben en este metodo.
  void _socketOnData(Uint8List data) {
    print(new String.fromCharCodes(data).trim());
  }

  void _socketOnDone() {
    _socket.destroy();
    print('Client: server closed connection.');
  }

  void _socketOnError(Object error) {}
}
