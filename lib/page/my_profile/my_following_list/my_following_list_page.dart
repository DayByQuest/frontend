import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../../model/class/user.dart';
import '../../../model/dataSource/mock_data_source.dart';
import '../../../model/repository/user_repository.dart';
import '../../common/Appbar.dart';
import '../../common/Buttons.dart';
import 'my_following_list_page_model.dart';

class MyFollowingListPage extends StatelessWidget {
  const MyFollowingListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        return MyFollowingListViewModel(
            userRepository: UserRepository(remoteDataSource: MockDataSource()));
      },
      child: MyFollowingListView(),
    );
  }
}

class MyFollowingListView extends StatelessWidget {
  const MyFollowingListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackSpaceAppBar(
        appBar: AppBar(),
        title: "팔로잉",
        isContextPopTrue: false,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: FollwingList(),
      ),
    );
  }
}

class FollwingList extends StatelessWidget {
  const FollwingList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    MyFollowingListViewModel viewModel =
        context.read<MyFollowingListViewModel>();

    return PagedListView<int, User>(
      pagingController: viewModel.pagingController,
      builderDelegate: PagedChildBuilderDelegate<User>(
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
    MyFollowingListViewModel viewModel =
        context.read<MyFollowingListViewModel>();
    User user = context.watch<MyFollowingListViewModel>().followingList[index];
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
