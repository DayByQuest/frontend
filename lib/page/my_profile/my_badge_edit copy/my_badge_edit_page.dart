import 'package:flutter/material.dart';
import 'package:flutter_application_1/page/common/Appbar.dart';
import 'package:flutter_application_1/page/common/Loding.dart';
import 'package:flutter_application_1/provider/error_status_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../../model/dataSource/mock_data_source.dart';
import '../../../model/repository/user_repository.dart';
import '../../common/Buttons.dart';
import '../../common/Status.dart';
import 'my_badge_edit_page_model.dart';
import '../../../model/class/badge.dart' as BadgeClass;

class MyBadgeEditPage extends StatelessWidget {
  const MyBadgeEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyBadgeEditViewModel>(
        create: (_) {
          final MyBadgeEditViewModel viewModel = MyBadgeEditViewModel(
            userRepository: UserRepository(),
            errorStatusProvider: context.read<ErrorStatusProvider>(),
          );
          return viewModel;
        },
        child: MyBadgeEditView());
  }
}

class MyBadgeEditView extends StatefulWidget {
  const MyBadgeEditView({super.key});

  @override
  State<MyBadgeEditView> createState() => _MyBadgeEditView();
}

class _MyBadgeEditView extends State<MyBadgeEditView> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    MyBadgeEditViewModel viewModel = context.read<MyBadgeEditViewModel>();
    Status status = context.watch<MyBadgeEditViewModel>().status;
    bool isLoding = status == Status.loading;

    void changeBadgeList() async {
      await viewModel.patchBadgeList();
      context.pop(true);
    }

    if (isLoding) {
      return Loading(context: context);
    }

    return Scaffold(
      appBar: BackSpaceAppBar(
        appBar: AppBar(),
        title: '뱃지 관리',
        isContextPopTrue: false,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 16, 5),
            child: Container(
              width: width * 0.2,
              child: CommonBtn(
                isPurple: false,
                btnTitle: '완료',
                context: context,
                onPressFunc: changeBadgeList,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: const Column(
        children: [
          CurBadgeList(),
          SizedBox(
            height: 16,
          ),
          AllBadgeList(),
        ],
      ),
    );
  }
}

class CurBadgeList extends StatelessWidget {
  const CurBadgeList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    MyBadgeEditViewModel viewModel = context.read<MyBadgeEditViewModel>();
    List<BadgeClass.Badge> currentBadList =
        context.watch<MyBadgeEditViewModel>().myCurrentBadList;

    double height = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        constraints: BoxConstraints(minHeight: height * 0.125),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: DragTarget<BadgeClass.Badge>(
          builder: (
            BuildContext context,
            List<dynamic> accepted,
            List<dynamic> rejected,
          ) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                crossAxisCount: 5,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: List.generate(currentBadList.length, (index) {
                  return CurBadgeItem(
                    badge: currentBadList[index],
                    index: index,
                  );
                }),
              ),
            );
          },
          onAccept: (BadgeClass.Badge badge) {
            viewModel.addNewBadge(badge);
          },
        ),
      ),
    );
  }
}

class CurBadgeItem extends StatelessWidget {
  const CurBadgeItem({
    super.key,
    required this.badge,
    required this.index,
  });

  final BadgeClass.Badge badge;
  final int index;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double itemSize = width * 0.13;
    MyBadgeEditViewModel viewModel = context.read<MyBadgeEditViewModel>();

    return Stack(
      children: [
        Draggable<BadgeClass.Badge>(
          data: badge,
          feedback: Container(
            color: Colors.deepOrange,
            height: itemSize,
            width: itemSize,
            child: Image.network(
              badge.imageUrl,
              fit: BoxFit.fill,
            ),
          ),
          childWhenDragging: Container(
            height: itemSize,
            width: itemSize,
            child: Image.network(
              badge.imageUrl,
              fit: BoxFit.fill,
            ),
          ),
          child: DragTarget<BadgeClass.Badge>(
            builder: (
              BuildContext context,
              List<dynamic> accepted,
              List<dynamic> rejected,
            ) {
              return Container(
                height: itemSize,
                width: itemSize,
                child: Image.network(
                  badge.imageUrl,
                  fit: BoxFit.fill,
                ),
              );
            },
            onAccept: (BadgeClass.Badge badge) {
              viewModel.dropBadge(badge, index);
            },
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
            icon: Icon(
              Icons.close,
            ),
            onPressed: () {
              viewModel.removeBadge(index);
            },
          ),
        ),
      ],
    );
  }
}

class AllBadgeList extends StatelessWidget {
  const AllBadgeList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    MyBadgeEditViewModel viewModel = context.read<MyBadgeEditViewModel>();
    double height = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: height * 0.35,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: PagedGridView<String, BadgeClass.Badge>(
            shrinkWrap: true,
            showNewPageProgressIndicatorAsGridChild: true,
            showNewPageErrorIndicatorAsGridChild: true,
            showNoMoreItemsIndicatorAsGridChild: true,
            pagingController: viewModel.pagingController,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 1 / 1,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              crossAxisCount: 5,
            ),
            builderDelegate: PagedChildBuilderDelegate<BadgeClass.Badge>(
              itemBuilder: (context, badge, index) =>
                  BadgeItem(badge: badge, index: index),
            ),
          ),
        ),
      ),
    );
  }
}

class BadgeItem extends StatelessWidget {
  const BadgeItem({
    super.key,
    required this.badge,
    required this.index,
  });

  final BadgeClass.Badge badge;
  final int index;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double itemSize = width * 0.13;

    return Draggable<BadgeClass.Badge>(
      data: badge,
      feedback: Container(
        height: itemSize,
        width: itemSize,
        child: Image.network(
          badge.imageUrl,
          fit: BoxFit.fill,
        ),
      ),
      childWhenDragging: Container(
        color: Colors.pinkAccent,
        child: Image.network(
          badge.imageUrl,
          fit: BoxFit.fill,
        ),
      ),
      child: Container(
        color: Colors.cyan,
        child: Image.network(
          badge.imageUrl,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
