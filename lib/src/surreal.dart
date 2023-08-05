import 'strategy/surreal_socket.dart';

class Surreal {
  /// The URL of the surrealdb client
  final Uri clientUrl;

  late SurrealSocket _socket;

  Surreal(String clientUrl)
      : clientUrl = Uri.parse(clientUrl + (clientUrl.endsWith('/rpc') ? '' : '/rpc')) {
    // Assert that the client URL is a WebSocket URL
    assert(this.clientUrl.scheme == 'ws' || this.clientUrl.scheme == 'wss');

    _socket = SurrealSocket(this.clientUrl);

    _socket.open();
  }
}
