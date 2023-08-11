import 'dart:convert';

import 'socket_response_error.dart';
import 'socket_response_result.dart';

abstract class SocketResponse {
  int id;

  SocketResponse({required this.id});

  factory SocketResponse.fromJson(Map<String, dynamic> json) {
    switch (json) {
      case {'id': int _, 'result': dynamic _}:
        return SocketResponseResult.fromJson(json);
      case {'id': int, 'error': dynamic?}:
        return SocketResponseError.fromJson(json);
      default:
        throw Exception('Invalid response'); // TODO: Handle this error
    }
  }

  factory SocketResponse.fromString(String response) {
    final json = jsonDecode(response);
    return SocketResponse.fromJson(json);
  }
}
