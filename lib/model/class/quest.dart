class Quest {
  final int id;
  final String title;
  final String state;

  Quest({
    required this.id,
    required this.title,
    required this.state,
  });

  factory Quest.fromJson(Map<String, dynamic> json) {
    return Quest(
      id: json['id'],
      title: json['title'],
      state: json['state'],
    );
  }
}
