import 'dart:collection';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../types/socket_message.dart';
import '../types/socket_status.dart';
import '../utils/incremental_id.dart';
import '../utils/observable.dart';
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
    print('opening socket');

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

    print('message sent');

    return message.response;
  }

  void _onSocketOpenned(_) async {
    print('socket openned');
    _statusObserver.value = SocketStatus.connected;

    _pinger.start(() {
      send(SocketMessage(id: IncrementalId.id, method: 'ping'));
    });
  }

  void _onSocketMessage(message) {
    print(message.runtimeType);
    print('socket message: $message');
  }

  void _onSocketError(error) {
    print('socket error: $error');
    _statusObserver.value = SocketStatus.socketError;
    // TODO: Handle socket error
  }
}
