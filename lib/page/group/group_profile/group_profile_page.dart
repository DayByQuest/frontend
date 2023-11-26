import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/class/group.dart';
import 'package:flutter_application_1/model/class/quest_detail.dart';
import 'package:flutter_application_1/model/repository/group_repository.dart';
import 'package:flutter_application_1/model/repository/quest_repository.dart';
import 'package:flutter_application_1/page/common/Appbar.dart';
import 'package:flutter_application_1/page/common/Buttons.dart';
import 'package:flutter_application_1/page/common/Gap.dart';
import 'package:flutter_application_1/page/common/Loding.dart';
import 'package:flutter_application_1/page/common/Status.dart';
import 'package:flutter_application_1/page/group/group_profile/group_profile_page_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../common/forward_bar.dart';

class GroupProfilePage extends StatelessWidget {
  final int groupId;

  const GroupProfilePage({
    super.key,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupProfileViewModel>(
      create: (_) {
        final GroupProfileViewModel viewModel = GroupProfileViewModel(
          groupRepositoty: GroupRepositoty(),
          questRepository: QuestRepository(),
          groupId: groupId,
        );
        return viewModel;
      },
      child: const GroupProfileView(),
    );
  }
}

class GroupProfileView extends StatelessWidget {
  const GroupProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    GroupProfileViewModel viewModel = context.read<GroupProfileViewModel>();
    bool isLoding =
        context.watch<GroupProfileViewModel>().status == Status.loading;

    if (isLoding) {
      viewModel.load();
      return Loading(context: context);
    }

    Group group = viewModel.group;
    String imageUrl = group.imageUrl;
    String groupName = group.name;
    String description = group.description;
    int groupId = group.groupId;
    bool isGroupManager = group.isGroupManager;
    List<QuestDetail> questList = viewModel.groupQuestList;
    bool canCreateQuset = isGroupManager && questList.length < 10;
    bool isGroupMember = group.isGroupMember;
    int userCount = group.userCount;
    bool errorStatus = context.read<GroupProfileViewModel>().errorStatus;
    String errorMessage = context.read<GroupProfileViewModel>().errorMessage;

    if (errorStatus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showErrorSnackBarFun(context, errorMessage);
        context.read<GroupProfileViewModel>().setErrorStatus(false, '');
      });
    }

    void createQuest() {
      context.push('/create-group-quest?groupId=${groupId}');
    }

    void joinGroup() {
      if (isGroupMember) {
        viewModel.quitGroup(groupId);
        return;
      }

      viewModel.joinGroup(groupId);
      return;
    }

    void moveGroupPost() {
      context.push('/group-post?groupId=${groupId}');
    }

    void moveGroupMemberList() {
      context.push('/group-member-list?groupId=${groupId}');
    }

    void moveGroupQuestJudgement() {
      context.push('/group-quest-judgement?groupId=${groupId}');
    }

    return Scaffold(
      appBar: BackSpaceAppBar(
        appBar: AppBar(),
        title: '그룹이름',
        isContextPopTrue: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {},
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            groupName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  SizedBox(
                    width: 78,
                    height: 28,
                    child: CommonBtn(
                      isPurple: !isGroupMember,
                      onPressFunc: () {
                        joinGroup();
                      },
                      context: context,
                      btnTitle: isGroupMember ? "탈퇴" : "가입",
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
              const Gap16(),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      description,
                    ),
                  ),
                ],
              ),
              const Gap16(),
              ForwardBar(
                description: '게시물 조회',
                moveTarget: () {
                  moveGroupPost();
                },
              ),
              const Gap16(),
              ForwardBar(
                description: '멤버: ${userCount.toString()}명',
                moveTarget: () {
                  moveGroupMemberList();
                },
              ),
              const Gap16(),
              isGroupManager
                  ? ForwardBar(
                      description: '게시물 판정하기',
                      moveTarget: () {
                        moveGroupQuestJudgement();
                      },
                    )
                  : Container(),
              const Gap16(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '퀘스트 목록',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  canCreateQuset
                      ? Container(
                          width: 77,
                          height: 28,
                          child: CommonBtn(
                            isPurple: true,
                            onPressFunc: () {
                              createQuest();
                            },
                            context: context,
                            btnTitle: '생성',
                            fontSize: 16,
                          ),
                        )
                      : Container(),
                ],
              ),
              questList.isNotEmpty
                  ? Column(
                      children: [
                        Gap16(),
                        ListView.separated(
                          separatorBuilder: (context, index) {
                            return Gap16();
                          },
                          shrinkWrap: true,
                          primary: false,
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return QuestItem(index: index);
                          },
                        )
                      ],
                    )
                  : Center(
                      child: Text('퀘스트가 없습니다.'),
                    ),
            ],
          ),
        ),
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
    GroupProfileViewModel viewModel = context.read<GroupProfileViewModel>();
    QuestDetail quest =
        context.watch<GroupProfileViewModel>().groupQuestList[index];
    int questId = quest.id;
    String questTitle = quest.title;
    String questDescriotion = quest.content;
    String state = quest.state;
    int currentCount = quest.currentCount;
    bool isDoing = state == QuestMap[QuestState.DOING];

    void onClick() {
      if (isDoing) {
        viewModel.questDelete(questId, index);
        return;
      }

      viewModel.questAccept(questId, index);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
                Text('그룹 퀘스트'),
              ],
            ),
            Container(
              width: 62,
              height: 28,
              child: CommonBtn(
                isPurple: isDoing,
                onPressFunc: () {
                  onClick();
                },
                context: context,
                btnTitle: isDoing ? '삭제' : '신청',
                fontSize: 16,
              ),
            )
          ],
        ),
        Gap8(),
        Text(
          questDescriotion,
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
                    '${currentCount}',
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

void showErrorSnackBarFun(BuildContext context, String message) {
  SnackBar snackBar = SnackBar(
    duration: Duration(milliseconds: 400),
    action: SnackBarAction(
      label: '취소',
      onPressed: () {},
      textColor: Colors.black,
    ),
    content: Text(
      message,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
    ),
    shape: Border.all(
      color: Colors.black,
    ),
    backgroundColor: Colors.white,
    dismissDirection: DismissDirection.up,
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.only(
      bottom: MediaQuery.of(context).size.height - 150,
      left: 10,
      right: 10,
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
