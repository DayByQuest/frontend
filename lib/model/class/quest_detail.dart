import 'package:flutter_dotenv/flutter_dotenv.dart';

class QuestDetail {
  final int id;
  final String category;
  final String title;
  final String content;
  final String expiredAt;
  final String interest;
  final String imageUrl;
  final String state;
  int? rewardCount;
  final int currentCount;
  final String? groupName;

  static String? IMAGE_BASE_URL = dotenv.env['IMAGE_BASE_URL'] ?? '';

  QuestDetail({
    required this.id,
    required this.category,
    required this.title,
    required this.content,
    required this.expiredAt,
    required this.interest,
    required this.imageUrl,
    required this.state,
    required this.rewardCount,
    required this.currentCount,
    this.groupName,
  });

  factory QuestDetail.fromJson(Map<String, dynamic> json) {
    return QuestDetail(
      id: json['id'] as int,
      category: json['category'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      expiredAt: json['expiredAt'] as String,
      interest: json['interest'] as String,
      imageUrl: '${IMAGE_BASE_URL}${json['imageIdentifier']}',
      state: json['state'] as String,
      rewardCount: json['rewardCount'] ?? null,
      currentCount: json['currentCount'] as int,
      groupName: json['groupName'] as String?,
    );
  }
}

class QuestDetailList {
  final List<QuestDetail> quests;

  QuestDetailList({
    required this.quests,
  });

  factory QuestDetailList.fromJson(Map<String, dynamic> json) {
    final List<dynamic> questList = json['quests'];
    final quests =
        questList.map((quest) => QuestDetail.fromJson(quest)).toList();

    return QuestDetailList(
      quests: quests,
    );
  }
}
