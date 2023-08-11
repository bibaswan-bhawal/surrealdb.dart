import 'dart:async';
import 'dart:convert';

import 'socket_response.dart';

class SocketMessage {
  final int id;
  final String method;
  final List<dynamic> params;

  final Completer<SocketResponse> completer = Completer<SocketResponse>();

  SocketMessage({required this.id, required this.method, this.params = const []});

  Future<SocketResponse> get response => completer.future;

  String toJson() => jsonEncode({'id': id, 'method': method, 'params': params});

  @override
  String toString() => toJson();
}
