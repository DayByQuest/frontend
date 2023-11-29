import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/class/post_image.dart';
import 'package:flutter_application_1/model/class/post_images.dart';
import 'package:flutter_application_1/model/class/quest_detail.dart';
import 'package:flutter_application_1/model/repository/quest_repository.dart';
import 'package:flutter_application_1/page/common/Appbar.dart';
import 'package:flutter_application_1/page/common/Buttons.dart';
import 'package:flutter_application_1/page/common/Gap.dart';
import 'package:flutter_application_1/page/common/Loding.dart';
import 'package:flutter_application_1/page/common/Status.dart';
import 'package:flutter_application_1/page/common/forward_bar.dart';
import 'package:flutter_application_1/page/common/post/post_bar.dart';
import 'package:flutter_application_1/page/common/post/post_image_view.dart';
import 'package:flutter_application_1/page/common/showDialog.dart';
import 'package:flutter_application_1/page/quest/example_quest/example_quest_page_model.dart';
import 'package:flutter_application_1/page/quest/quest_porfile/quest_profile_page_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class QuestProfilePage extends StatelessWidget {
  final int questId;
  final QuestDetail quest;

  const QuestProfilePage({
    super.key,
    required this.questId,
    required this.quest,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<QuestProfileViewModel>(
      create: (_) {
        final QuestProfileViewModel viewModel = QuestProfileViewModel(
          questRepository: QuestRepository(),
          questId: questId,
          quest: quest,
        );
        return viewModel;
      },
      child: QuestProfileView(),
    );
  }
}

class QuestProfileView extends StatelessWidget {
  const QuestProfileView({
    Key? key,
  }) : super(key: key);

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 32;
    QuestProfileViewModel viewModel = context.read<QuestProfileViewModel>();
    Status status = context.watch<QuestProfileViewModel>().status;
    QuestDetail quest = viewModel.quest;
    int questId = quest.id;

    if (status == Status.loading) {
      viewModel.load();
      return Loading(context: context);
    }

    String dscription = context.read<QuestProfileViewModel>().description;
    PostImages exampleImages =
        context.watch<QuestProfileViewModel>().exampleImages;
    List<PostImage> imageList = exampleImages.postImageList;
    int imageLength = imageList.length;
    int curImageIndex = exampleImages.index;

    void changeCurIdx(nextImageIndex) {
      viewModel.changeCurImageIndex(nextImageIndex);
    }

    void moveQuestPost() {
      context.push('/quest-post?questId=$questId');
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: BackSpaceAppBar(
          appBar: AppBar(),
          title: '퀘스트 프로필',
          isContextPopTrue: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              QuestItem(),
              Gap16(),
              ForwardBar(
                  description: '게시물 조회',
                  moveTarget: () {
                    moveQuestPost();
                  }),
              Gap16(),
              PostImageView(
                width: width,
                imageList: imageList,
                imageLength: imageLength,
                changeCurIdx: changeCurIdx,
              ),
              Stack(
                children: [
                  SizedBox(
                    height: 48,
                    width: width,
                    child: DotsIndicator(
                      dotsCount: imageLength,
                      position: curImageIndex,
                    ),
                  ),
                  SizedBox(
                    height: 48,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuestItem extends StatelessWidget {
  const QuestItem({super.key});

  @override
  Widget build(BuildContext context) {
    QuestProfileViewModel viewModel = context.read<QuestProfileViewModel>();
    QuestDetail quest = context.watch<QuestProfileViewModel>().quest;
    String questState = quest.state;

    if (questState == QuestMap[QuestState.DOING]) {
      return DoingQuestItem();
    }

    if (questState == QuestMap[QuestState.NOT]) {
      return NewQuestItem();
    }
    return FinishQuestItem();
  }
}

class DoingQuestItem extends StatelessWidget {
  const DoingQuestItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    QuestProfileViewModel viewModel = context.read<QuestProfileViewModel>();
    QuestDetail quest = context.watch<QuestProfileViewModel>().quest;
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
      await viewModel.completeQuest(questId);
    }

    void cancelAccept() async {
      try {
        await viewModel.cancelAcceptQuest(questId);
      } catch (e) {}
    }

    void handleCloseBtn() {
      showMyDialog(context, '', '$questTitle 퀘스트 수행을 취소하시겠습니까?', '취소', '확인',
          cancelAccept);
    }

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
              Row(
                children: [
                  canShowButtton
                      ? Container(
                          width: 77,
                          height: 28,
                          child: CommonBtn(
                            isPurple: canGetReward,
                            onPressFunc: () {
                              completeQuest();
                            },
                            context: context,
                            btnTitle: '완료',
                            fontSize: 16,
                          ),
                        )
                      : Container(),
                  Gap8(),
                  IconButton(
                    onPressed: () {
                      handleCloseBtn();
                    },
                    icon: Icon(
                      Icons.close,
                    ),
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
  const NewQuestItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    QuestProfileViewModel viewModel = context.read<QuestProfileViewModel>();
    QuestDetail quest = context.watch<QuestProfileViewModel>().quest;
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
        await viewModel.acceptQuest(questId);
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
  const FinishQuestItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    QuestProfileViewModel viewModel = context.read<QuestProfileViewModel>();
    QuestDetail quest = context.watch<QuestProfileViewModel>().quest;
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
      viewModel.restartQuest(questId);
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
