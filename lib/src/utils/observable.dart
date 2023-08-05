typedef Listener<T> = void Function(T value);

class Observable<T> {
  T _value;

  final List<Listener<T>> _listeners = <Listener<T>>[];

  Observable(this._value);

  set value(T value) {
    _value = value;
    notify();
  }

  T get value => _value;

  void addListener(Listener<T> listener) {
    _listeners.add(listener);
  }

  void removeListener(Listener<T> listener) {
    _listeners.remove(listener);
  }

  void notify() {
    for (final listener in _listeners) {
      listener(value);
    }
  }

  void dispose() {
    _listeners.clear();
  }
}
