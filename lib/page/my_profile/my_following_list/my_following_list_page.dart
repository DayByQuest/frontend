import 'package:flutter/material.dart';
import 'package:flutter_application_1/page/common/empty_list.dart';
import 'package:flutter_application_1/provider/error_status_provider.dart';
import 'package:flutter_application_1/provider/follow_status_provider.dart';
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
          errorStatusProvider: context.read<ErrorStatusProvider>(),
          followStatusProvider: context.read<FollowStatusProvider>(),
          userRepository: UserRepository(),
        );
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
        noItemsFoundIndicatorBuilder: (context) {
          return ShowEmptyList(content: '팔로우하는 사용자가 없습니다');
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
    MyFollowingListViewModel viewModel =
        context.read<MyFollowingListViewModel>();
    User user = context.watch<MyFollowingListViewModel>().followingList[index];
    String imageUrl = user.imageUrl;
    String name = user.name;
    String username = user.username;
    bool isFollowing = context.watch<FollowStatusProvider>().hasUser(username);

    void follow() async {
      await viewModel.postFollow(username);
    }

    void unFollow() async {
      await viewModel.deleteFollow(username);
    }

    void moveUserProfile() {
      context.go('/user-profile?username=$username');
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
                    isPurple: !isFollowing,
                    onPressFunc: isFollowing ? unFollow : follow,
                    context: context,
                    btnTitle: isFollowing ? "팔로우" : "팔로잉",
                    fontSize: 16,
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
