import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/class/group.dart';
import 'package:flutter_application_1/model/repository/group_repository.dart';
import 'package:flutter_application_1/page/common/Buttons.dart';
import 'package:flutter_application_1/page/common/Gap.dart';
import 'package:flutter_application_1/page/common/Loding.dart';
import 'package:flutter_application_1/page/common/Status.dart';
import 'package:flutter_application_1/page/common/empty_list.dart';
import 'package:flutter_application_1/page/group/my_group_list/my_group_list_page_model.dart';
import 'package:flutter_application_1/provider/error_status_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MyGroupListPage extends StatelessWidget {
  const MyGroupListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyGroupListViewModel>(
      create: (_) {
        final MyGroupListViewModel viewModel = MyGroupListViewModel(
          errorStatusProvider: context.read<ErrorStatusProvider>(),
          groupRepositoty: GroupRepositoty(),
        );
        return viewModel;
      },
      child: MyGroupListView(),
    );
  }
}

class MyGroupListView extends StatelessWidget {
  const MyGroupListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 32;
    double height = MediaQuery.of(context).size.height - 32;
    final MyGroupListViewModel viewModel = context.read<MyGroupListViewModel>();
    bool isLoading =
        context.watch<MyGroupListViewModel>().status == Status.loading;
    List<Group> groupList = context.read<MyGroupListViewModel>().groupList;
    int groupCount = groupList.length;
    bool canMakeGroup = groupCount < 10;

    if (isLoading) {
      viewModel.load();
      return Loading(context: context);
    }

    void moveCreateGroup() async {
      bool? isLoad = await context.push<bool>('/create-group');

      if (isLoad ?? false) {
        debugPrint("뒤로가기 감지 동작! ${isLoad}");
        viewModel.setStatusLoding();
      }
    }

    if (groupList.isEmpty) {
      return Container(
        padding: EdgeInsets.all(16),
        width: width,
        height: height,
        child: Stack(
          children: [
            const ShowEmptyList(content: '내가 가입한 그룹이 없습니다'),
            canMakeGroup
                ? Positioned(
                    bottom: 16,
                    child: Container(
                      height: 48,
                      width: width,
                      child: CommonBtn(
                        isPurple: true,
                        onPressFunc: () {
                          moveCreateGroup();
                        },
                        context: context,
                        btnTitle: '생성',
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        children: [
          ListView.builder(
            itemCount: (groupCount + 1),
            itemBuilder: (context, index) {
              if (groupCount == index) {
                return SizedBox(
                  height: 80,
                );
              }

              return GroupItem(
                index: index,
              );
            },
          ),
          canMakeGroup
              ? Positioned(
                  bottom: 16,
                  child: Container(
                    height: 48,
                    width: width,
                    child: CommonBtn(
                      isPurple: true,
                      onPressFunc: () {
                        moveCreateGroup();
                      },
                      context: context,
                      btnTitle: '생성',
                    ),
                  ),
                )
              : Container(),
        ],
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
    Group curGroup = context.read<MyGroupListViewModel>().groupList[index];
    String imageUrl = curGroup.imageUrl;
    String name = curGroup.name;
    String userCount = '멤버수: ${curGroup.userCount}명';
    String description = curGroup.description;
    int groupId = curGroup.groupId;
    String url = '/group-profile?groupId=$groupId';

    void moveUserProfile() {
      debugPrint("move!");
      context.go(url);
    }

    return InkWell(
      onTap: () {
        moveUserProfile();
      },
      child: Column(
        children: [
          Container(
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
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        userCount,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      Gap8(),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
