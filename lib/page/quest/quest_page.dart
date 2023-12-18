import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/class/quest_detail.dart';
import 'package:flutter_application_1/model/repository/quest_repository.dart';
import 'package:flutter_application_1/page/common/Appbar.dart';
import 'package:flutter_application_1/page/common/Buttons.dart';
import 'package:flutter_application_1/page/common/Gap.dart';
import 'package:flutter_application_1/page/common/Loding.dart';
import 'package:flutter_application_1/page/common/Status.dart';
import 'package:flutter_application_1/page/common/empty_list.dart';
import 'package:flutter_application_1/page/common/showDialog.dart';
import 'package:flutter_application_1/page/common/showSnackBarFunction.dart';
import 'package:flutter_application_1/page/quest/quest_page_model.dart';
import 'package:flutter_application_1/provider/error_status_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class QuestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<QuestViewModel>(
      create: (_) {
        final QuestViewModel viewModel = QuestViewModel(
          errorStatusProvider: context.read<ErrorStatusProvider>(),
          questRepository: QuestRepository(),
        );
        return viewModel;
      },
      child: QuestView(),
    );
  }
}

class QuestView extends StatelessWidget {
  const QuestView({super.key});

  @override
  Widget build(BuildContext context) {
    QuestViewModel viewModel = context.read<QuestViewModel>();
    bool isLoading = context.watch<QuestViewModel>().status == Status.loading;
    bool messageStatus = context.watch<QuestViewModel>().messageStatus;
    String message = context.watch<QuestViewModel>().message;

    if (isLoading) {
      viewModel.load();
      return Loading(context: context);
    }

    if (messageStatus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showSnackBarFun(context, message);
        context.read<QuestViewModel>().setMessageStatus(false, '');
      });
    }

    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 48.0,
          iconTheme: const IconThemeData(color: Colors.black),
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          title: const Text(
            '퀘스트',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          bottom: TabBar(
            labelColor: Colors.black,
            indicatorColor: Color(0xFF82589F),
            onTap: (int value) {
              debugPrint('value $value');
              return;
            },
            tabs: const <Widget>[
              Tab(
                child: Text(
                  '진행중',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Tab(
                child: Text(
                  '신규',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Tab(
                child: Text(
                  '완료',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
        body: const Column(
          children: [
            Flexible(
              child: TabBarView(
                children: <Widget>[
                  DoingQuestList(),
                  NewQuestList(),
                  FinishQuestList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DoingQuestList extends StatelessWidget {
  const DoingQuestList({super.key});

  @override
  Widget build(BuildContext context) {
    QuestViewModel viewModel = context.read<QuestViewModel>();
    bool isRefresh = viewModel.isRefreshDoingQuset();
    List<QuestDetail> doingQuestList =
        context.watch<QuestViewModel>().doingQuestList;
    int questLength = doingQuestList.length;

    if (isRefresh) {
      viewModel.setChangeStatus(ChangeStatus.nothing, false);
    }

    if (questLength == 0) {
      return ShowEmptyList(content: '수행중인 퀘스트가 없습니다.');
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: questLength,
        itemBuilder: (context, index) {
          return DoingQuestItem(index: index);
        },
      ),
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
    double width = MediaQuery.of(context).size.width - 32;
    QuestViewModel viewModel = context.read<QuestViewModel>();
    List<QuestDetail> doingQuestList =
        context.watch<QuestViewModel>().doingQuestList;
    QuestDetail quest = doingQuestList[index];
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

    void completeQuest() async {
      await viewModel.completeQuest(questId, index);
    }

    void cancelAccept() async {
      try {
        await viewModel.cancelAcceptQuest(questId, index);
      } catch (e) {}
    }

    void handleCloseBtn() {
      showMyDialog(context, '', '$questTitle 퀘스트 수행을 취소하시겠습니까?', '취소', '확인',
          cancelAccept);
    }

    void moveQuestProfile() async {
      bool? isLoad = await context.push<bool>('/quest-profile?questId=$questId',
          extra: quest);

      if (isLoad == true) {
        viewModel.load();
      }
    }

    return AnimatedCrossFade(
      duration: Duration(milliseconds: 300),
      firstChild: InkWell(
        onTap: () {
          moveQuestProfile();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DoingQuestInforBar(
              imageUrl: imageUrl,
              width: width,
              questTitle: questTitle,
              questCategory: questCategory,
              canShowButtton: canShowButtton,
              canGetReward: canGetReward,
              handleCommonBtn: completeQuest,
              handleCloseBtn: handleCloseBtn,
            ),
            Gap8(),
            Text(
              description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
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
      ),
      secondChild: SizedBox(),
      crossFadeState: !canShowAnimation
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
    );
  }
}

class DoingQuestInforBar extends StatelessWidget {
  DoingQuestInforBar({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.questTitle,
    required this.questCategory,
    required this.canShowButtton,
    required this.canGetReward,
    required this.handleCommonBtn,
    required this.handleCloseBtn,
  });

  final String imageUrl;
  final double width;
  final String questTitle;
  final String questCategory;
  final bool canShowButtton;
  final bool canGetReward;
  Function handleCommonBtn;
  Function handleCloseBtn;

  @override
  Widget build(BuildContext context) {
    return Row(
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
            SizedBox(
              width: width - 166,
              child: Column(
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
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          child: Row(
            children: [
              canShowButtton
                  ? Container(
                      width: 77,
                      height: 28,
                      child: CommonBtn(
                        isPurple: canGetReward,
                        onPressFunc: () {
                          handleCommonBtn();
                        },
                        context: context,
                        btnTitle: '완료',
                        fontSize: 16,
                      ),
                    )
                  : Container(),
              Gap8(),
              SizedBox(
                width: 25,
                child: IconButton(
                  padding: EdgeInsets.zero, // 패딩 설정
                  constraints: BoxConstraints(), // constraints
                  onPressed: () {
                    handleCloseBtn();
                  },
                  icon: Icon(
                    Icons.close,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class NewQuestList extends StatelessWidget {
  const NewQuestList({super.key});

  @override
  Widget build(BuildContext context) {
    QuestViewModel viewModel = context.read<QuestViewModel>();
    bool isRefresh = viewModel.isRefreshNewQuset();
    List<QuestDetail> newQuestList =
        context.watch<QuestViewModel>().newQuestList;
    int questLength = newQuestList.length;

    if (isRefresh) {
      viewModel.setChangeStatus(ChangeStatus.nothing, false);
    }

    if (questLength == 0) {
      return ShowEmptyList(content: '새로운 퀘스트가 없습니다.');
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.separated(
        separatorBuilder: (context, index) {
          return Gap16();
        },
        itemCount: questLength,
        itemBuilder: (context, index) {
          return NewQuestItem(index: index);
        },
      ),
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
    double width = MediaQuery.of(context).size.width - 32;
    QuestViewModel viewModel = context.read<QuestViewModel>();
    List<QuestDetail> newQuestList =
        context.watch<QuestViewModel>().newQuestList;
    QuestDetail quest = newQuestList[index];
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

    void moveQuestProfile() async {
      bool? isLoad = await context.push<bool>('/quest-profile?questId=$questId',
          extra: quest);

      if (isLoad == true) {
        viewModel.load();
      }
    }

    return InkWell(
      onTap: () {
        moveQuestProfile();
      },
      child: Column(
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
                  SizedBox(
                    width: width - 166,
                    child: Column(
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
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
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
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
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
      ),
    );
  }
}

class FinishQuestList extends StatelessWidget {
  const FinishQuestList({super.key});

  @override
  Widget build(BuildContext context) {
    QuestViewModel viewModel = context.read<QuestViewModel>();
    bool isRefresh = viewModel.isRefreshNewQuset();
    List<QuestDetail> finishedQuestList =
        context.watch<QuestViewModel>().finishedQuestList;
    int questLength = finishedQuestList.length;

    if (isRefresh) {
      viewModel.setChangeStatus(ChangeStatus.nothing, false);
    }

    if (questLength == 0) {
      return const Center(
        child: Text('완료한 퀘스트가 없습니다.'),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: questLength,
        itemBuilder: (context, index) {
          return FinishQuestItem(index: index);
        },
      ),
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
    double width = MediaQuery.of(context).size.width - 32;
    QuestViewModel viewModel = context.read<QuestViewModel>();
    List<QuestDetail> finishedQuestList =
        context.watch<QuestViewModel>().finishedQuestList;
    QuestDetail quest = finishedQuestList[index];
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
    String questExpiredAt = quest.expiredAt!;
    String expiredAt = hasExpiredAt ? '기한: $questExpiredAt' : '기한: 무기한';
    bool canShowAnimation = quest.canShowAnimation;

    void restartQuest() {
      viewModel.restartQuest(questId, index);
    }

    void moveQuestProfile() async {
      bool? isLoad = await context.push<bool>('/quest-profile?questId=$questId',
          extra: quest);

      if (isLoad == true) {
        viewModel.load();
      }
    }

    return AnimatedCrossFade(
      duration: Duration(milliseconds: 300),
      crossFadeState: !canShowAnimation
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      firstChild: InkWell(
        onTap: () {
          moveQuestProfile();
        },
        child: Column(
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
                    SizedBox(
                      width: width - 166,
                      child: Column(
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
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
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
      ),
      secondChild: Container(),
    );
  }
}
