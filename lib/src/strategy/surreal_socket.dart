import 'dart:async';
import 'dart:collection';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../types/socket/socket_message.dart';
import '../types/socket/socket_response.dart';
import '../types/socket/socket_status.dart';
import '../utils/incremental_id.dart';
import '../utils/observable.dart';
import '../utils/pinger.dart';

class SurrealSocket {
  /// The URL of the surrealdb client
  final Uri clientUrl;

  /// Pinger instance to keep the connection alive
  final Pinger _pinger = Pinger();

  /// Queue of active queries sent to surrealdb
  final Queue<SocketMessage> _messageQueue = Queue<SocketMessage>();

  /// Observable status of the socket
  final Observable<SocketStatus> _statusObserver = Observable(SocketStatus.unknown);

  /// The websocket channel
  WebSocketChannel? _socketChannel;

  Completer _isReadyCompleter = Completer();

  SurrealSocket(this.clientUrl);

  /// The current status of the socket
  SocketStatus get status => _statusObserver.value;
  Future get isReady => _isReadyCompleter.future;

  /// Opens a websocket connection to surrealdb
  void open() {
    _socketChannel = WebSocketChannel.connect(clientUrl);
    _statusObserver.value = SocketStatus.connecting;

    // Subscribe to socket open event
    _socketChannel?.ready.then(_onSocketOpenned, onError: _onSocketError);

    // Subscribe to socket events
    _socketChannel?.stream.listen(
      _onSocketMessage,
      onError: _onSocketError,
      onDone: _onSocketClosed,
    );
  }

  /// Sends a message to surrealdb over websocket
  Future<SocketResponse> send(SocketMessage message) {
    if (status != SocketStatus.connected) {
      throw Exception('Socket is not openned'); // TODO: Handle this error
    }

    _socketChannel?.sink.add(message.toJson());
    _messageQueue.add(message);

    print('message sent: $message | Queue length: ${_messageQueue.length}');

    return message.response;
  }

  void close() {
    _socketChannel?.sink.close();
  }

  /// Event handlers - Socket openned
  void _onSocketOpenned(_) async {
    _statusObserver.value = SocketStatus.connected;
    _isReadyCompleter.complete();

    _pinger.start(() {
      final pingMessage = SocketMessage(id: IncrementalId.id, method: 'ping');
      send(pingMessage);
    });
  }

  /// Event handlers - Received new message from socket
  void _onSocketMessage(dynamic message) {
    /* 
     * Validate the message is a string probably changes 
     * when the surreal binary protocol is implemented
     */
    if (message.runtimeType != String) {
      throw Exception('Invalid message type'); // TODO: Handle this error
    }

    print("Response received: $message | Queue length: ${_messageQueue.length}");
    // Parse the the socket message
    final SocketResponse response = SocketResponse.fromString(message);
    final SocketMessage query = _messageQueue.firstWhere((element) => element.id == response.id);

    // complete the query
    query.completer.complete(response);

    // remove the query from the queue
    _messageQueue.removeWhere((element) => element.id == response.id);
  }

  /// Event handlers - Socket error
  void _onSocketError(error) {
    print('socket error: $error');
    _statusObserver.value = SocketStatus.socketError;
    _isReadyCompleter = Completer(); // TODO: This might not be right should handle this error
    // TODO: Handle socket error
  }

  /// Event handlers - Socket closed
  void _onSocketClosed() {
    _statusObserver.value = SocketStatus.disconnected;
    _isReadyCompleter = Completer();
  }
}
