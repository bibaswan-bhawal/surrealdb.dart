import 'surreal_auth.dart';

class SurrealDatabaseAuth implements SurrealAuth {
  final String user;
  final String pass;
  final String ns;
  final String db;

  SurrealDatabaseAuth({
    required this.user,
    required this.pass,
    required this.ns,
    required this.db,
  });

  @override
  Map<String, dynamic> get params => {
        "NS": ns,
        "DB": db,
        "user": user,
        "pass": pass,
      };
}
