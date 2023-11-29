import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/class/group.dart';
import 'package:flutter_application_1/model/class/quest_detail.dart';
import 'package:flutter_application_1/model/class/user.dart';
import 'package:flutter_application_1/model/repository/group_repository.dart';
import 'package:flutter_application_1/model/repository/quest_repository.dart';
import 'package:flutter_application_1/model/repository/user_repository.dart';
import 'package:flutter_application_1/page/common/Buttons.dart';
import 'package:flutter_application_1/page/common/Gap.dart';
import 'package:flutter_application_1/page/search/search_result/search_result_page_model.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class SearchResultPage extends StatelessWidget {
  final String keyword;

  const SearchResultPage({
    super.key,
    required this.keyword,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchResultViewModel>(
      create: (_) {
        final SearchResultViewModel viewModel = SearchResultViewModel(
          questRepository: QuestRepository(),
          userRepository: UserRepository(),
          groupRepositoty: GroupRepositoty(),
          keyword: keyword,
        );
        return viewModel;
      },
      child: SearchResultView(),
    );
  }
}

class SearchResultView extends StatelessWidget {
  const SearchResultView({super.key});

  @override
  Widget build(BuildContext context) {
    SearchResultViewModel viewModel = context.read<SearchResultViewModel>();
    TextEditingController textEditingController =
        viewModel.textEditingController;

    void moveSearchResult(String keyword) {
      context.go('/search?keyword=$keyword');
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: DefaultTabController(
        length: 3,
        initialIndex: 0,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            toolbarHeight: 48.0,
            iconTheme: const IconThemeData(color: Colors.black),
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ), // 뒤로가기 아이콘
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Container(
              height: 48.0,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                controller: textEditingController,
                onChanged: (value) {},
                onSubmitted: (value) {
                  moveSearchResult(value);
                },
              ),
            ),
            bottom: TabBar(
              labelColor: Colors.black,
              onTap: (int value) {
                debugPrint('value $value');
                return;
              },
              tabs: const <Widget>[
                Tab(
                  child: Text(
                    '사용자',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Tab(
                  child: Text(
                    '그룹',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Tab(
                  child: Text(
                    '퀘스트',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          body: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Flexible(
                  child: TabBarView(
                    children: <Widget>[
                      Center(
                        child: SearchUserList(),
                      ),
                      Center(
                        child: SearchGroupListView(),
                      ),
                      Center(
                        child: SearchQuestList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SearchUserList extends StatelessWidget {
  const SearchUserList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    SearchResultViewModel viewModel = context.read<SearchResultViewModel>();

    return PagedListView<int, User>(
      pagingController: viewModel.userPagingController,
      builderDelegate: PagedChildBuilderDelegate<User>(
        itemBuilder: (context, user, index) => UserListItem(
          index: index,
        ),
        noItemsFoundIndicatorBuilder: (context) {
          return const Center(
            child: Text('해당하는 사용자가 없습니다.'),
          );
        },
      ),
    );
  }
}

class UserListItem extends StatelessWidget {
  const UserListItem({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    SearchResultViewModel viewModel = context.read<SearchResultViewModel>();
    User user = context.watch<SearchResultViewModel>().searchUserList[index];
    String imageUrl = user.imageUrl;
    String name = user.name;
    String username = user.username;
    bool isFollwing = user.following;

    void follow() async {
      await viewModel.postFollow(username, index);
    }

    void unFollow() async {
      await viewModel.deleteFollow(username, index);
    }

    return Column(
      children: [
        Container(
          width: double.infinity,
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  context.push('/user-profile?username=$username');
                },
                child: Container(
                  width: 48,
                  height: 48,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      username,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: 77,
                height: 28,
                child: CommonBtn(
                  isPurple: isFollwing,
                  onPressFunc: isFollwing ? unFollow : follow,
                  context: context,
                  btnTitle: isFollwing ? "팔로잉" : "팔로우",
                  fontSize: 16,
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }
}

class SearchGroupListView extends StatelessWidget {
  const SearchGroupListView({super.key});

  @override
  Widget build(BuildContext context) {
    SearchResultViewModel viewModel = context.read<SearchResultViewModel>();

    return PagedListView<int, Group>(
      pagingController: viewModel.groupPagingController,
      builderDelegate: PagedChildBuilderDelegate<Group>(
        itemBuilder: (context, user, index) => GroupItem(
          index: index,
        ),
        noItemsFoundIndicatorBuilder: (context) {
          return const Center(
            child: Text('해당하는 그룹이 없습니다.'),
          );
        },
      ),
    );
  }
}

class GroupItem extends StatelessWidget {
  final int index;

  const GroupItem({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    SearchResultViewModel viewModel = context.read<SearchResultViewModel>();
    Group group = context.watch<SearchResultViewModel>().searchGroupList[index];
    int groupId = group.groupId;
    String imageUrl = group.imageUrl;
    String groupName = group.name;
    int userCount = group.userCount;
    String description = group.description;
    bool isMember = group.isGroupMember;

    void btnClick() {
      if (isMember) {
        viewModel.quitGroup(groupId, index);
        return;
      }
      viewModel.joinGroup(groupId, index);
    }

    void moveGroupProfile() {
      context.push('/group-profile?groupId=$groupId');
    }

    return Column(
      children: [
        InkWell(
          onTap: () {
            moveGroupProfile();
          },
          child: SizedBox(
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        groupName,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        '멤버수: $userCount명',
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      Gap8(),
                      Text(
                        description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 80,
                  height: 28,
                  child: CommonBtn(
                    isPurple: !isMember,
                    onPressFunc: () {
                      btnClick();
                    },
                    context: context,
                    btnTitle: !isMember ? '가입' : '탈퇴',
                    fontSize: 16,
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }
}

class SearchQuestList extends StatelessWidget {
  const SearchQuestList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    SearchResultViewModel viewModel = context.read<SearchResultViewModel>();

    return PagedListView<int, QuestDetail>(
      pagingController: viewModel.questPagingController,
      builderDelegate: PagedChildBuilderDelegate<QuestDetail>(
        itemBuilder: (context, quest, index) => QuestItem(
          index: index,
        ),
        noItemsFoundIndicatorBuilder: (context) {
          return const Center(
            child: Text('해당하는 퀘스트가 없습니다.'),
          );
        },
      ),
    );
  }
}

class QuestItem extends StatelessWidget {
  final int index;

  const QuestItem({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    SearchResultViewModel viewModel = context.read<SearchResultViewModel>();
    QuestDetail quest =
        context.read<SearchResultViewModel>().searchQuestList[index];
    String questState = quest.state;

    if (questState == QuestMap[QuestState.NOT]) {
      return NewQuestItem(
        index: index,
      );
    }

    if (questState == QuestMap[QuestState.FINISHED]) {
      return FinishQuestItem(
        index: index,
      );
    }

    return DoingQuestItem(
      index: index,
    );
  }
}

class DoingQuestItem extends StatelessWidget {
  final int index;

  const DoingQuestItem({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    SearchResultViewModel viewModel = context.read<SearchResultViewModel>();
    QuestDetail quest =
        context.watch<SearchResultViewModel>().searchQuestList[index];
    int questId = quest.id;
    String imageUrl = quest.imageUrl;
    String questTitle = quest.title;
    bool isGroupQuest = quest.groupName != null;
    String questCategory = isGroupQuest ? quest.groupName! : '어드민 퀘스트';
    String description = quest.content;
    int? rewardCount = quest.rewardCount;
    int currentCount = quest.currentCount;
    bool canGetReward =
        !isGroupQuest && (rewardCount != null && rewardCount <= currentCount);
    bool canShowButtton = (isGroupQuest && 0 < currentCount) || canGetReward;
    String count =
        isGroupQuest ? '$currentCount' : '$currentCount/$rewardCount';
    bool canShowAnimation = quest.canShowAnimation;

    return AnimatedCrossFade(
      duration: Duration(milliseconds: 300),
      firstChild: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Gap8(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        questTitle,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        questCategory,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Gap8(),
          Text(
            description,
          ),
          Gap8(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    height: 20,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.0),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      '$count',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Gap16(),
        ],
      ),
      secondChild: SizedBox(),
      crossFadeState: !canShowAnimation
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
    );
  }
}

class NewQuestItem extends StatelessWidget {
  final int index;

  const NewQuestItem({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    SearchResultViewModel viewModel = context.read<SearchResultViewModel>();
    QuestDetail quest =
        context.watch<SearchResultViewModel>().searchQuestList[index];
    int questId = quest.id;
    String imageUrl = quest.imageUrl;
    String questTitle = quest.title;
    bool isGroupQuest = quest.groupName != null;
    String questCategory = isGroupQuest ? quest.groupName! : '뱃지 증정';
    String description = quest.content;
    int? rewardCount = quest.rewardCount;
    int currentCount = quest.currentCount;
    String count =
        isGroupQuest ? '$currentCount' : '$currentCount/$rewardCount';
    bool hasExpiredAt = quest.expiredAt != null;
    String? questExpiredAt = quest.expiredAt;
    String expiredAt = hasExpiredAt ? '기한: $questExpiredAt' : '기한: 무기한';
    bool canShowAnimation = quest.canShowAnimation;

    void acceptQuest() async {
      try {
        await viewModel.acceptQuest(questId, index);
      } catch (e) {}
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 48,
                  height: 48,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                Gap8(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      questTitle,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      questCategory,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              crossFadeState: !canShowAnimation
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: Container(
                width: 77,
                height: 28,
                child: CommonBtn(
                  isPurple: true,
                  onPressFunc: () {
                    acceptQuest();
                  },
                  context: context,
                  btnTitle: '수행',
                  fontSize: 16,
                ),
              ),
              secondChild: Container(
                width: 77,
                height: 28,
                child: CommonIconBtn(
                  isPurple: true,
                  onPressFunc: () {},
                  context: context,
                  icon: Icons.check,
                ),
              ),
            ),
          ],
        ),
        Gap8(),
        Text(
          description,
        ),
        Gap8(),
        Text(expiredAt),
        Gap8(),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  height: 20,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.0),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    '$count',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}

class FinishQuestItem extends StatelessWidget {
  final int index;

  const FinishQuestItem({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    SearchResultViewModel viewModel = context.read<SearchResultViewModel>();
    QuestDetail quest =
        context.read<SearchResultViewModel>().searchQuestList[index];
    int questId = quest.id;
    String imageUrl = quest.imageUrl;
    String questTitle = quest.title;
    bool isGroupQuest = quest.groupName != null;
    String questCategory = isGroupQuest ? quest.groupName! : '뱃지 증정';
    String description = quest.content;
    int? rewardCount = quest.rewardCount;
    int currentCount = quest.currentCount;
    String count =
        isGroupQuest ? '$currentCount' : '$currentCount/$rewardCount';
    bool hasExpiredAt = quest.expiredAt != null;
    String questExpiredAt = '23/10/02 23:55까지';
    String expiredAt = hasExpiredAt ? '기한: $questExpiredAt' : '기한: 무기한';
    bool canShowAnimation = quest.canShowAnimation;

    void restartQuest() {
      viewModel.restartQuest(
        questId,
        index,
      );
    }

    return AnimatedCrossFade(
      duration: Duration(milliseconds: 300),
      crossFadeState: !canShowAnimation
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      firstChild: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Gap8(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        questTitle,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        questCategory,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              AnimatedCrossFade(
                duration: const Duration(seconds: 1),
                crossFadeState: !canShowAnimation
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                firstChild: Container(
                  width: 77,
                  height: 28,
                  child: CommonBtn(
                    isPurple: true,
                    onPressFunc: () {
                      restartQuest();
                    },
                    context: context,
                    btnTitle: '재개',
                    fontSize: 16,
                  ),
                ),
                secondChild: Container(
                  width: 77,
                  height: 28,
                  child: CommonIconBtn(
                    isPurple: true,
                    onPressFunc: () {},
                    context: context,
                    icon: Icons.check,
                  ),
                ),
              ),
            ],
          ),
          Gap8(),
          Text(
            description,
          ),
          Gap8(),
          Text(expiredAt),
          Gap8(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    height: 20,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.0),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      '$count',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Gap16(),
        ],
      ),
      secondChild: Container(),
    );
  }
}
