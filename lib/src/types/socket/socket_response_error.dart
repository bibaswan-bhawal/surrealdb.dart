import 'dart:convert';

import 'socket_response.dart';

class SocketResponseError extends SocketResponse {
  final String? error;

  SocketResponseError({required super.id, required this.error});

  factory SocketResponseError.fromJson(Map<String, dynamic> json) {
    // TODO: Add type for error
    return SocketResponseError(id: json['id'], error: jsonEncode(json['result']));
  }

  @override
  String toString() {
    return 'SocketResponseError(id: $id, error: $error)';
  }
}
