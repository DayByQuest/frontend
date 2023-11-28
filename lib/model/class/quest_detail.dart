import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum QuestState {
  DOING,
  FINISHED,
  CONTINUE,
  NOT,
  SUCCESS,
  NOT_SEEK,
  FAIL,
  NEW,
}

Map<QuestState, String> QuestMap = {
  QuestState.DOING: "DOING",
  QuestState.FINISHED: "FINISHED",
  QuestState.CONTINUE: "CONTINUE",
  QuestState.NOT: "NOT",
  QuestState.SUCCESS: "SUCCESS",
  QuestState.NOT_SEEK: "NOT_SEEK",
  QuestState.FAIL: 'FAIL',
};

class QuestDetail {
  final int id;
  final String category;
  final String title;
  final String content;
  final String? expiredAt;
  final String interest;
  final String imageUrl;
  String state;
  int? rewardCount;
  final int currentCount;
  final String? groupName;
  bool canShowAnimation;

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
    required this.canShowAnimation,
  });

  factory QuestDetail.fromJson(Map<String, dynamic> json) {
    return QuestDetail(
      id: json['id'],
      category: json['category'],
      title: json['title'],
      content: json['content'],
      expiredAt: json['expiredAt'],
      interest: json['interest'],
      imageUrl: '${IMAGE_BASE_URL}${json['imageIdentifier']}',
      state: json['state'],
      rewardCount: json['rewardCount'] ?? null,
      currentCount: json['currentCount'],
      groupName: json['groupName'],
      canShowAnimation: false,
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
