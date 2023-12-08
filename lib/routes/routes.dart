import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/model/class/quest_detail.dart';
import 'package:flutter_application_1/page/group/create_group/create_group_page.dart';
import 'package:flutter_application_1/page/group/create_group_quest/create_detail_group_quest_page.dart';
import 'package:flutter_application_1/page/group/create_group_quest/create_group_quest_page.dart';
import 'package:flutter_application_1/page/group/groupPage.dart';
import 'package:flutter_application_1/page/group/group_member_list/group_member_page.dart';
import 'package:flutter_application_1/page/group/group_post/group_post_page.dart';
import 'package:flutter_application_1/page/group/group_profile/group_profile_page.dart';
import 'package:flutter_application_1/page/group/group_quest_judgment/group_quest_judgment_page.dart';
import 'package:flutter_application_1/page/my_profile/account_disclosure/account_disclosure_page.dart';
import 'package:flutter_application_1/page/my_profile/my_badge_edit%20copy/my_badge_edit_page.dart';
import 'package:flutter_application_1/page/my_profile/my_follower_list/my_follower_list_page.dart';
import 'package:flutter_application_1/page/my_profile/my_following_list/my_following_list_page.dart';
import 'package:flutter_application_1/page/my_profile/my_interest/my_interest_page.dart';
import 'package:flutter_application_1/page/my_profile/my_post/my_post_page.dart';
import 'package:flutter_application_1/page/my_profile/profile_image_edit/profile_image_edit_page.dart';
import 'package:flutter_application_1/page/post/detail_post_page.dart';
import 'package:flutter_application_1/page/profile/profile_page.dart';
import 'package:flutter_application_1/page/quest/example_quest/example_quest_page.dart';
import 'package:flutter_application_1/page/quest/quest_page.dart';
import 'package:flutter_application_1/page/quest/quest_porfile/quest_profile_page.dart';
import 'package:flutter_application_1/page/quest/quest_post/quest_post_page.dart';
import 'package:flutter_application_1/page/search/search_result/search_result_page.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const MainPage();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'account-disclosure',
          builder: (BuildContext context, GoRouterState state) {
            return AccountDisclosurePage();
          },
        ),
        GoRoute(
          path: 'myinterest',
          builder: (context, state) {
            return MyInterestPage();
          },
        ),
        GoRoute(
          path: 'profile-image-edit',
          builder: (context, state) {
            String url = state.uri.queryParameters['imageurl'] ?? 'null';
            return ProfileImageEditPage(
              imageUrl: url,
            );
          },
        ),
        GoRoute(
          path: 'my-post',
          builder: (context, state) {
            String username = state.uri.queryParameters['username'] ?? 'null';
            return MyPostPage(username: username);
          },
        ),
        GoRoute(
          path: 'my-follower-list',
          builder: (context, state) {
            return MyFollowerListPage();
          },
        ),
        GoRoute(
          path: 'my-following-list',
          builder: (context, state) {
            return MyFollowingListPage();
          },
        ),
        GoRoute(
          path: 'badge-edit',
          builder: (BuildContext context, GoRouterState state) {
            return MyBadgeEditPage();
          },
        ),
        GoRoute(
          path: 'user-profile',
          builder: (context, state) {
            String username = state.uri.queryParameters['username'] ?? 'null';
            return ProfilePage(
              username: username,
            );
          },
        ),
        GoRoute(
          path: 'detail',
          builder: (context, state) {
            String stringPostId = state.uri.queryParameters['postId'] ?? '0';
            int postId = int.parse(stringPostId);
            return DetailPage(
              postId: postId,
            );
          },
        ),
        GoRoute(
          path: 'group',
          builder: (context, state) {
            return GroupPage();
          },
        ),
        GoRoute(
          path: 'main',
          builder: (context, state) {
            return MyHomePage();
          },
        ),
        GoRoute(
          path: 'group-profile',
          builder: (context, state) {
            int groupId = int.parse(state.uri.queryParameters['groupId']!) ?? 0;
            return GroupProfilePage(groupId: groupId);
          },
        ),
        GoRoute(
          path: 'group-post',
          builder: (context, state) {
            int groupId = int.parse(state.uri.queryParameters['groupId']!) ?? 0;
            return GroupPostPage(groupId: groupId);
          },
        ),
        GoRoute(
          path: 'group-member-list',
          builder: (context, state) {
            int groupId = int.parse(state.uri.queryParameters['groupId']!) ?? 0;
            return GroupMemberListPage(groupId: groupId);
          },
        ),
        GoRoute(
          path: 'group-quest-judgement',
          builder: (context, state) {
            int groupId = int.parse(state.uri.queryParameters['groupId']!) ?? 0;
            return GroupQuestJudgmentPage(groupId: groupId);
          },
        ),
        GoRoute(
          path: 'create-group-quest',
          builder: (context, state) {
            int groupId = int.parse(state.uri.queryParameters['groupId']!) ?? 0;
            return CreateGroupQuestPage(
              groupId: groupId,
            );
          },
        ),
        GoRoute(
          path: 'create-detail-group-quest',
          builder: (context, state) {
            int questId = int.parse(state.uri.queryParameters['questId']!) ?? 0;
            return CreateDetailGroupQuestPage(
              questId: questId,
            );
          },
        ),
        GoRoute(
          path: 'create-group',
          builder: (context, state) {
            return CreateGroupPage();
          },
        ),
        GoRoute(
          path: 'example-quest',
          builder: (context, state) {
            int questId = int.parse(state.uri.queryParameters['questId']!) ?? 0;
            return ExampleQuestPage(questId: questId);
          },
        ),
        GoRoute(
          path: 'quest',
          builder: (context, state) {
            return QuestPage();
          },
        ),
        GoRoute(
          path: 'quest-profile',
          builder: (context, state) {
            int questId = int.parse(state.uri.queryParameters['questId']!) ?? 0;
            QuestDetail quest = GoRouterState.of(context).extra as QuestDetail;
            return QuestProfilePage(
              questId: questId,
              quest: quest,
            );
          },
        ),
        GoRoute(
          path: 'quest-post',
          builder: (context, state) {
            int questId = int.parse(state.uri.queryParameters['questId']!) ?? 0;
            return QuestPostPage(questId: questId);
          },
        ),
        GoRoute(
          path: 'search',
          builder: (context, state) {
            String keyword = state.uri.queryParameters['keyword'] ?? '0';
            return SearchResultPage(
              keyword: keyword,
            );
          },
        ),
      ],
    ),
  ],
);
