class Tracker {
  final List<int> _tracker;

  Tracker({required List<int> tracker}) : _tracker = tracker;

  List<int> get tracker => _tracker.reversed.toList();
}
