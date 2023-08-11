
import 'surreal_auth.dart';

class SurrealRootAuth implements SurrealAuth {
  final String user;
  final String pass;

  SurrealRootAuth({required this.user, required this.pass});

  @override
  Map<String, dynamic> get params => {"user": user, "pass": pass};
}
