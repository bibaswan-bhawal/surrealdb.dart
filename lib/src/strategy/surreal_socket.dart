import 'dart:collection';
import 'package:surrealdb/src/types/socket_message.dart';
import 'package:surrealdb/src/utils/observable.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../types/socket_status.dart';
import '../utils/pinger.dart';

class SurrealSocket {
  /// The URL of the surrealdb client
  final Uri clientUrl;

  final Pinger _pinger = Pinger();
  final Queue<SocketMessage> _messageQueue = Queue<SocketMessage>();
  final Observable<SocketStatus> _statusObserver = Observable(SocketStatus.unknown);

  WebSocketChannel? _socketChannel;

  SurrealSocket(this.clientUrl);

  void open() {
    _socketChannel = WebSocketChannel.connect(clientUrl);
    _statusObserver.value = SocketStatus.connecting;

    // Socket openned
    _socketChannel?.ready.then(_onSocketOpenned, onError: _onSocketError);

    _socketChannel?.stream.listen(_onSocketMessage);
  }

  /// Sends a message to surrealdb over websocket
  /// TODO: replace dynamic with a type
  Future<dynamic> send(SocketMessage message) {
    if (_socketChannel == null) throw Exception('Socket is not openned'); // TODO: Handle this error

    _socketChannel?.sink.add(message.toJson());
    _messageQueue.add(message);

    print('message setn');

    return message.response;
  }

  void _onSocketOpenned(_) async {
    _statusObserver.value = SocketStatus.connected;

    _pinger.start(() {
      send(SocketMessage(id: 1, method: 'ping'));
    });
  }

  void _onSocketMessage(data) {
    print(data.runtimeType);
  }

  void _onSocketError(error) {
    _statusObserver.value = SocketStatus.socketError;
    // TODO: Handle socket error
  }
}
