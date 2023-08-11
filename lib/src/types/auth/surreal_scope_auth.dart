import 'surreal_auth.dart';

class SurrealScopeAuth implements SurrealAuth {
  final String ns;
  final String db;
  final String scope;

  final Map<String, dynamic> scopeParams;

  SurrealScopeAuth({
    required this.ns,
    required this.db,
    required this.scope,
    required this.scopeParams,
  });

  @override
  Map<String, dynamic> get params => {
        "NS": ns,
        "DB": db,
        "scope": scope,
        ...scopeParams,
      };
}
