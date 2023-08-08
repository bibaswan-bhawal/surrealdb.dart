class IncrementalId {
  static int _id = 0;

  static int get id => _id = (_id + 1) % double.maxFinite.toInt();

  static void reset() => _id = 0;
}
