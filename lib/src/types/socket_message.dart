import 'dart:async';

class SocketMessage {
  final int id;
  final String method;
  final List<dynamic> data;

  final Completer<dynamic> _completer = Completer<dynamic>();

  SocketMessage({required this.id, required this.method, this.data = const []});

  Future<dynamic> get response => _completer.future;

  String toJson() => '{"id": $id, "method": "$method", "data": $data}';

  @override
  String toString() => toJson();
}
