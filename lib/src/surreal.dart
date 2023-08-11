import 'strategy/surreal_socket.dart';
import 'types/auth/surreal_auth.dart';
import 'types/socket/socket_message.dart';
import 'types/socket/socket_response_error.dart';
import 'types/socket/socket_response_result.dart';
import 'utils/incremental_id.dart';

class Surreal {
  /// The URL of the surrealdb client
  final String clientUrl;

  late SurrealSocket _socket;

  Surreal(this.clientUrl) {
    final clientUri = Uri.parse(clientUrl);

    // TODO: Add parsing for uri

    _socket = SurrealSocket(clientUri);
  }

  Future<void> connect() async {
    _socket.open();
    await _socket.isReady;
  }

  Future<void> use({required String ns, required String db}) async {
    final newMessage = SocketMessage(
      id: IncrementalId.id,
      method: "use",
      params: [ns, db],
    );

    try {
      final response = await _socket.send(newMessage);

      switch (response.runtimeType) {
        case SocketResponseResult:
          return;
        case SocketResponseError:
          print((response as SocketResponseError).error);
      }
    } catch (e) {
      print(e); // TODO: Handle this error - Socket is not openned or
    }
  }

  /// TODO: Add proper typed AuthParams
  Future<dynamic> signin(SurrealAuth authParams) async {
    final newMessage = SocketMessage(
      id: IncrementalId.id,
      method: "signin",
      params: [authParams.params],
    );

    try {
      final response = _socket.send(newMessage);

      switch (response.runtimeType) {
        case SocketResponseResult:
          print(response);
          return response;
        case SocketResponseError:
          print((response as SocketResponseError).error);
          throw Exception("Error signing in");
      }
    } catch (e) {
      print(e); // TODO: Handle this error - Socket is not openned or
      rethrow;
    }
  }

  Future<void> query<T>(String query, [Map<String, dynamic>? variables]) async {
    final newMessage =
        SocketMessage(id: IncrementalId.id, method: 'query', params: [query, variables ?? {}]);

    try {
      final response =
          await _socket.send(newMessage); // Throws an error if the socket is not openned

      switch (response.runtimeType) {
        case SocketResponseResult:
          print((response as SocketResponseResult).result);
        case SocketResponseError:
          print((response as SocketResponseError).error);
      }
    } catch (e) {
      print(e); // TODO: Handle this error - Socket is not openned or
    }
  }

  void close() {
    _socket.close();
  }
}
