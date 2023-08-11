import 'dart:async';

/// A class that pings a callback function every [_interval].
/// Used to keep the WebSocket connection alive.
final class Pinger {
  /// The interval between each ping.
  final Duration _interval;

  /// A dart timer object that calls the callback function every [_interval].
  Timer? _timer;

  /// Constructs a  new piner object
  Pinger([this._interval = const Duration(seconds: 30)]);

  /// Starts the pinger.
  void start(void Function() callback) => _timer = Timer.periodic(_interval, (_) => callback());

  /// Stops the pinger.
  void stop() => _timer?.cancel();
}
