class PostImage {
  String imageUrl;
  bool isSwipe;

  PostImage({required this.imageUrl, bool? isSwipe})
      : isSwipe = isSwipe ?? false;

  factory PostImage.fromJson(Map<String, dynamic> json) {
    return PostImage(
      imageUrl: json['imageUrl'],
      isSwipe: json['isSwipe'] ?? false,
    );
  }
}
