import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/class/quest.dart';
import 'package:flutter_application_1/model/class/quest_detail.dart';
import 'package:flutter_application_1/model/dataSource/mock_data_source.dart';
import 'package:flutter_application_1/model/repository/quest_repository.dart';
import 'package:flutter_application_1/page/common/Appbar.dart';
import 'package:flutter_application_1/page/common/Buttons.dart';
import 'package:flutter_application_1/page/common/Loding.dart';
import 'package:flutter_application_1/page/common/Status.dart';
import 'package:flutter_application_1/page/create_post/quest_list/quest_list_page_model.dart';
import 'package:flutter_application_1/provider/error_status_provider.dart';
import 'package:provider/provider.dart';

class QuestListPage extends StatelessWidget {
  const QuestListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<QuestListViewModel>(
      create: (_) {
        final QuestListViewModel viewModel = QuestListViewModel(
          errorStatusProvider: context.read<ErrorStatusProvider>(),
          questRepository: QuestRepository(),
        );
        return viewModel;
      },
      child: QuestListView(),
    );
  }
}

class QuestListView extends StatelessWidget {
  const QuestListView({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 32;
    final QuestListViewModel viewModel = context.read<QuestListViewModel>();
    bool isLoading =
        context.watch<QuestListViewModel>().status == Status.loading;
    List<QuestDetail> questList = context.read<QuestListViewModel>().questList;
    int questLength = questList.length;
    int questTargetIndex = context.watch<QuestListViewModel>().questTargetIndex;
    bool hasSeletedQuest = 0 <= questTargetIndex;

    void onChaged(isChecked, curIndex) {
      viewModel.changeQuestTarget(isChecked, curIndex);
    }

    void checkedQuest() {
      Map<String, dynamic> Quest = viewModel.getSelctedQuest();
      Navigator.pop(context, Quest);
    }

    if (isLoading) {
      viewModel.load();
      return Loading(context: context);
    }

    if (questLength == 0) {
      return Scaffold(
        appBar: BackSpaceAppBar(
            appBar: AppBar(), title: '퀘스트 태그', isContextPopTrue: false),
        body: const Center(
          child: Text('수행 중인 퀘스트가 없습니다.'),
        ),
      );
    }

    return Scaffold(
      appBar: BackSpaceAppBar(
          appBar: AppBar(), title: '퀘스트 태그', isContextPopTrue: false),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            ListView.separated(
              itemCount: questLength + 1,
              separatorBuilder: (_, index) => const Divider(
                color: Colors.black,
              ),
              itemBuilder: (context, index) {
                if (questLength == index) {
                  return SizedBox(
                    height: 80,
                  );
                }

                String title = questList[index].title;
                String subTitle = questList[index].content;
                return QuestItem(
                  index: index,
                  curCheckedIndex: questTargetIndex,
                  title: title,
                  subTitle: subTitle,
                  onChanged: onChaged,
                );
              },
            ),
            Positioned(
              bottom: 16,
              child: Container(
                height: 48,
                width: width,
                child: CommonBtn(
                  isPurple: hasSeletedQuest,
                  onPressFunc: checkedQuest,
                  context: context,
                  btnTitle: '완료',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuestItem extends StatelessWidget {
  final int index; // 현재 인덱스
  final int curCheckedIndex; // 현재 체크되어있는 인덱스.
  final String title;
  final String subTitle;
  late bool isChecked = index == curCheckedIndex;
  Function onChanged;

  QuestItem({
    super.key,
    required this.index,
    required this.curCheckedIndex,
    required this.title,
    required this.subTitle,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: isChecked,
      onChanged: (bool? value) {
        onChanged(isChecked, index);
      },
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      subtitle: Text(
        subTitle,
        style: const TextStyle(
          fontSize: 14,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }
}
