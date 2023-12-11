import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/dataSource/mock_data_source.dart';
import 'package:flutter_application_1/model/repository/user_repository.dart';
import 'package:flutter_application_1/page/common/Appbar.dart';
import 'package:flutter_application_1/page/common/Buttons.dart';
import 'package:flutter_application_1/page/common/empty_list.dart';
import 'package:flutter_application_1/page/my_profile/my_follower_list/my_follower_list_page_model.dart';
import 'package:flutter_application_1/provider/error_status_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import '../../../model/class/user.dart';

class MyFollowerListPage extends StatelessWidget {
  const MyFollowerListPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        return MyFollowerListViewModel(
          errorStatusProvider: context.read<ErrorStatusProvider>(),
          userRepository: UserRepository(),
        );
      },
      child: MyFollowerListView(),
    );
  }
}

class MyFollowerListView extends StatelessWidget {
  const MyFollowerListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackSpaceAppBar(
        appBar: AppBar(),
        title: "팔로워",
        isContextPopTrue: false,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: FollwerList(),
      ),
    );
  }
}

class FollwerList extends StatelessWidget {
  const FollwerList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    MyFollowerListViewModel viewModel = context.read<MyFollowerListViewModel>();

    return PagedListView<int, User>(
      pagingController: viewModel.pagingController,
      builderDelegate: PagedChildBuilderDelegate<User>(
        noItemsFoundIndicatorBuilder: (context) {
          return ShowEmptyList(content: '나를 팔로우하는 사용자가 없습니다');
        },
        itemBuilder: (context, user, index) => ListItem(
          index: index,
        ),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  const ListItem({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    MyFollowerListViewModel viewModel = context.read<MyFollowerListViewModel>();
    User user = context.watch<MyFollowerListViewModel>().followerList[index];
    String imageUrl = user.imageUrl;
    String name = user.name;
    String username = user.username;
    bool? isDelete = user.isDelete;

    Future<void> deleteFollower() async {
      await viewModel.deleteFollower(username, index);
    }

    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('AlertDialog Title'),
            content: Text('$name 님을 팔로워 리스트에서 삭제하시겠어요?'),
            actions: <Widget>[
              TextButton(
                child: const Text('취소'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('삭제'),
                onPressed: () async {
                  await deleteFollower();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    if (isDelete) {
      return Container();
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
                  isPurple: false,
                  onPressFunc: _showMyDialog,
                  context: context,
                  btnTitle: '삭제',
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
