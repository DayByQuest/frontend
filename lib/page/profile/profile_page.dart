import 'package:flutter_application_1/page/common/Appbar.dart';
import 'package:flutter_application_1/page/common/Loding.dart';
import 'package:flutter_application_1/provider/error_status_provider.dart';
import 'package:flutter_application_1/provider/follow_status_provider.dart';
import 'package:flutter_application_1/widget/tracker_view.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../model/class/badge.dart' as BadgeClass;
import '../../model/class/user.dart';
import '../common/Buttons.dart';
import '../common/Status.dart';
import 'profile_page_model.dart';
import 'package:flutter/material.dart';
import './../../model/repository/user_repository.dart';
import './../../model/dataSource/mock_data_source.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.username});

  final String username;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfileViewModel>(
        create: (_) {
          final ProfileViewModel viewModel = ProfileViewModel(
            errorStatusProvider: context.read<ErrorStatusProvider>(),
            followStatusProvider: context.read<FollowStatusProvider>(),
            userRepository: UserRepository(),
            username: username,
          );
          return viewModel;
        },
        child: const ProfileView());
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileViewModel viewModel = context.read<ProfileViewModel>();
    bool isLoading = context.watch<ProfileViewModel>().status == Status.loading;

    if (isLoading) {
      viewModel.load();
      return Loading(context: context);
    }

    List<int> tracker = context.read<ProfileViewModel>().tracker;
    int postCount = context.read<ProfileViewModel>().user.postCount;

    return Scaffold(
      body: ListView(
        physics: const ScrollPhysics(),
        children: [
          MenuBar(),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                ProfileInfomation(),
                SizedBox(
                  height: 16,
                ),
                TrackerView(
                  tracker: tracker,
                  postCount: postCount,
                ),
                SizedBox(
                  height: 16,
                ),
                BadgeView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BadgeView extends StatelessWidget {
  const BadgeView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ProfileViewModel viewModel = context.read<ProfileViewModel>();
    List<BadgeClass.Badge> badge = viewModel.badge;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0), // GridView 주위에 16px의 패딩 설정
        child: GridView.count(
          crossAxisCount: 5,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: List.generate(badge.length, (index) {
            return Container(
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  badge[index].imageUrl,
                  fit: BoxFit.fill,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class ProfileInfomation extends StatelessWidget {
  const ProfileInfomation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ProfileViewModel viewModel = context.read<ProfileViewModel>();
    User user = context.watch<ProfileViewModel>().user;
    String username = user.username;
    bool isFollwing = context.watch<FollowStatusProvider>().hasUser(username);
    String postCount = '0';

    void follow() async {
      await viewModel.postFollow(username);
    }

    void unFollow() async {
      await viewModel.deleteFollow(username);
    }

    if (user.postCount != Null) {
      postCount = user.postCount >= 999 ? "999+" : user.postCount.toString();
    }

    return Container(
      constraints: const BoxConstraints(maxWidth: 800),
      child: AspectRatio(
        aspectRatio: 1 / 0.2935779816513761,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(user.imageUrl),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(postCount,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    )),
                const Text(
                  '게시물',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 8,
            ),
            Container(
              width: 91,
              height: 28,
              child: CommonBtn(
                isPurple: !isFollwing,
                onPressFunc: isFollwing ? unFollow : follow,
                context: context,
                btnTitle: isFollwing ? "팔로잉" : "팔로우",
                fontSize: 16,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MenuBar extends StatelessWidget {
  const MenuBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String username = context.read<ProfileViewModel>().username;

    return BackSpaceAppBar(
        appBar: AppBar(), title: username, isContextPopTrue: false);
  }
}
