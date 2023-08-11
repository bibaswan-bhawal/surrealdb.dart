import 'package:surrealdb_dart/surrealdb.dart';

void main() async {
  final Surreal surreal = Surreal('ws://localhost:8000/rpc'); // Add event listeners

  // Open a connection to surrealdb
  await surreal.connect();

  // Use the test database
  await surreal.use(ns: "test", db: "test");

  // Sign in as root
  final auth = SurrealRootAuth(user: "root", pass: "root");
  await surreal.signin(auth);
}

// TODO: Strongly type sign in responses

/// Root sign in response
final RootSignInResponse = {
  "result": "eyJ0eXAiOiJKV1QiLCJhbGciO",
  "id": 2,
};


