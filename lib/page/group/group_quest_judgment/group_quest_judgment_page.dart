import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/class/failed_post.dart';
import 'package:flutter_application_1/model/class/post_image.dart';
import 'package:flutter_application_1/model/class/quest_detail.dart';
import 'package:flutter_application_1/model/repository/group_repository.dart';
import 'package:flutter_application_1/model/repository/quest_repository.dart';
import 'package:flutter_application_1/page/common/Appbar.dart';
import 'package:flutter_application_1/page/common/Gap.dart';
import 'package:flutter_application_1/page/common/Loding.dart';
import 'package:flutter_application_1/page/common/Status.dart';
import 'package:flutter_application_1/page/common/forward_bar.dart';
import 'package:flutter_application_1/page/group/group_quest_judgment/group_quest_judgment_page_model.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class GroupQuestJudgmentPage extends StatelessWidget {
  final int groupId;

  const GroupQuestJudgmentPage({
    super.key,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupQuestJudgmentViewModel>(
      create: (_) {
        final GroupQuestJudgmentViewModel viewModel =
            GroupQuestJudgmentViewModel(
          groupRepositoty: GroupRepositoty(),
          questRepository: QuestRepository(),
          groupId: groupId,
        );
        return viewModel;
      },
      child: const GroupQuestJudgmentView(),
    );
  }
}

class GroupQuestJudgmentView extends StatelessWidget {
  const GroupQuestJudgmentView({super.key});

  @override
  Widget build(BuildContext context) {
    GroupQuestJudgmentViewModel viewModel =
        context.read<GroupQuestJudgmentViewModel>();
    bool isLoding =
        context.watch<GroupQuestJudgmentViewModel>().status == Status.loading;

    if (isLoding) {
      viewModel.load();
      return Loading(context: context);
    }

    List<QuestDetail> groupQuestList =
        context.read<GroupQuestJudgmentViewModel>().groupQuestList;

    if (groupQuestList.isEmpty) {
      return Scaffold(
        appBar: BackSpaceAppBar(
          appBar: AppBar(),
          title: '게시물 판정',
          isContextPopTrue: false,
        ),
        body: const Center(
          child: Text('그룹의 퀘스트가 없습니다.'),
        ),
      );
    }

    QuestDetail? selectQuest =
        context.watch<GroupQuestJudgmentViewModel>().selectQuest;
    String description = selectQuest!.content;
    int questId = selectQuest.id;

    void moveExampleQuest() {
      debugPrint('/example-quest?questId=$questId');
      context.push('/example-quest?questId=$questId');
    }

    return Scaffold(
      appBar: BackSpaceAppBar(
        appBar: AppBar(),
        title: '게시물 판정',
        isContextPopTrue: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            DropdownQuestMenu(),
            Gap16(),
            Text(
              description,
            ),
            Gap16(),
            ForwardBar(
                description: '예시 이미지 확인',
                moveTarget: () {
                  moveExampleQuest();
                }),
            Gap16(),
            FailedQuestList(),
          ],
        ),
      ),
    );
  }
}

class FailedQuestList extends StatefulWidget {
  const FailedQuestList({
    super.key,
  });

  @override
  State<FailedQuestList> createState() => _FailedQuestListState();
}

class _FailedQuestListState extends State<FailedQuestList> {
  CardSwiperController controller = CardSwiperController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 32;
    GroupQuestJudgmentViewModel viewModel =
        context.read<GroupQuestJudgmentViewModel>();
    bool isLoding = context.watch<GroupQuestJudgmentViewModel>().imageStatus ==
        Status.loading;
    bool isDoneQuestJudge =
        context.watch<GroupQuestJudgmentViewModel>().isDoneQuestJudge;
    List<FailedPost> failedPostList =
        context.watch<GroupQuestJudgmentViewModel>().failedPostList;
    int failedPostLength = failedPostList.length;

    void setIsDoneQuestJudge() {
      viewModel.setIsDoneQuestJudge();
    }

    if (isLoding) {
      viewModel.getFailedGroupQuestList();
      return Container(
        width: width,
        height: width,
        child: const Center(
          child: Text('로딩중...'),
        ),
      );
    }

    if (isDoneQuestJudge || failedPostList.isEmpty) {
      return Container(
        width: width,
        height: width,
        child: const Center(
          child: Text('판단해야할 퀘스트가 없습니다.'),
        ),
      );
    }

    return Column(
      children: [
        Container(
          width: width,
          height: width,
          child: CardSwiper(
            isLoop: false,
            controller: controller,
            isDisabled: true,
            cardsCount: failedPostLength,
            numberOfCardsDisplayed: 1,
            onEnd: () {
              setIsDoneQuestJudge();
            },
            onSwipe: (previousIndex, currentIndex, direction) {
              int postId = failedPostList[previousIndex].id;

              viewModel.changeImageLoadCount();

              if (CardSwiperDirection.left == direction) {
                viewModel.postJudgmentFail(postId);
                return true;
              }

              viewModel.postJudgmentSuccess(postId);
              return true;
            },
            cardBuilder: (context, index, horizontalOffsetPercentage,
                verticalOffsetPercentage) {
              debugPrint('index: $index');

              return FailedQuestItem(
                index: index,
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                controller.swipeLeft();
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                controller.swipeRight();
              },
              child: Text('승인'),
            ),
          ],
        )
      ],
    );
  }
}

class FailedQuestItem extends StatelessWidget {
  final int index;

  const FailedQuestItem({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 32;
    FailedPost failedPost =
        context.watch<GroupQuestJudgmentViewModel>().failedPostList[index];
    List<PostImage> imageList = failedPost.postImages.postImageList;
    int imageLength = failedPost.postImages.postImageList.length;

    return SizedBox(
      // 이미지
      width: width,
      height: width,
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Image.network(
            imageList[index].imageUrl,
            fit: BoxFit.contain,
          );
        },
        itemCount: imageLength,
        loop: false,
        onIndexChanged: (int nextImageIndex) {},
      ),
    );
  }
}

class DropdownQuestMenu extends StatefulWidget {
  const DropdownQuestMenu({super.key});

  @override
  State<DropdownQuestMenu> createState() => _DropdownQuestMenuState();
}

class _DropdownQuestMenuState extends State<DropdownQuestMenu> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 32;
    GroupQuestJudgmentViewModel viewModel =
        context.read<GroupQuestJudgmentViewModel>();
    List<QuestDetail> groupQuestList =
        context.read<GroupQuestJudgmentViewModel>().groupQuestList;
    QuestDetail? selectQuest =
        context.watch<GroupQuestJudgmentViewModel>().selectQuest;

    void setSelectQuest(QuestDetail? newSelectQuest) {
      viewModel.setSelectQuest(newSelectQuest);
    }

    return DropdownMenu<QuestDetail>(
      width: width,
      initialSelection: groupQuestList.first,
      onSelected: (QuestDetail? value) {
        setSelectQuest(value);
        debugPrint("value: ${value?.title}");
      },
      dropdownMenuEntries: groupQuestList
          .asMap()
          .entries
          .map<DropdownMenuEntry<QuestDetail>>(
              (MapEntry<int, QuestDetail> entry) {
        int index = entry.key;
        QuestDetail value = entry.value;
        return DropdownMenuEntry<QuestDetail>(
          value: groupQuestList[index],
          label: '${groupQuestList[index].title}',
        );
      }).toList(),
    );
  }
}
