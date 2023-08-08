import 'package:surrealdb/surrealdb.dart';

void main() async {
  final socket = SurrealSocket(Uri.parse('ws://localhost:8000/rpc'));
  socket.open();
}
 