class Badge {
  final String _name;
  final String _imageUrl;
  final String _id;
  final String _acquiredAt;

  Badge(
      {required String name,
      required String imageUrl,
      required String id,
      required String acquiredAt})
      : _name = name,
        _imageUrl = imageUrl,
        _id = id,
        _acquiredAt = acquiredAt;

  String get name => _name;
  String get imageUrl => _imageUrl;
  String get id => _id;
  String get acquiredAt => _acquiredAt;
}
