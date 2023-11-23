import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/class/group.dart';
import 'package:flutter_application_1/model/repository/group_repository.dart';
import 'package:flutter_application_1/page/common/Buttons.dart';
import 'package:flutter_application_1/page/common/Gap.dart';
import 'package:flutter_application_1/page/common/Loding.dart';
import 'package:flutter_application_1/page/common/Status.dart';
import 'package:flutter_application_1/page/group/my_group_list/my_group_list_page_model.dart';
import 'package:provider/provider.dart';

class MyGroupListPage extends StatelessWidget {
  const MyGroupListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyGroupListViewModel>(
      create: (_) {
        final MyGroupListViewModel viewModel = MyGroupListViewModel(
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

    if (groupList.isEmpty) {
      return const Center(
        child: Text('내가 가입한 그룹이 없습니다!'),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        children: [
          ListView.builder(
            itemCount: groupCount,
            itemBuilder: (context, index) {
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
                      onPressFunc: () {},
                      context: context,
                      btnTitle: '생성',
                    ),
                  ),
                )
              : Container()
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
    int groupId = curGroup.groupId;
    String imageUrl = curGroup.imageUrl;
    String name = curGroup.name;
    String userCount = '멤버수: ${curGroup.userCount}명';
    String description = curGroup.description;

    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          Container(
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {},
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
