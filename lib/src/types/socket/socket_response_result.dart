import 'dart:convert';

import 'socket_response.dart';

class SocketResponseResult extends SocketResponse {
  final String? result;

  SocketResponseResult({required super.id, required this.result});

  factory SocketResponseResult.fromJson(Map<String, dynamic> json) {
    // // TODO: Add type for result
    return SocketResponseResult(id: json['id'], result: jsonEncode(json['result']));
  }

  @override
  String toString() {
    return 'SocketResponseResult(id: $id, result: $result)';
  }
}
