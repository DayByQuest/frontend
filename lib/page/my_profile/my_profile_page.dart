import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../model/class/badge.dart' as BadgeClass;
import '../../model/class/user.dart';
import '../common/Status.dart';
import './my_profile_page_model.dart';
import 'package:flutter/material.dart';
import './../../model/repository/user_repository.dart';
import './../../model/dataSource/mock_data_source.dart';

class MyProfilePage extends StatelessWidget {
  const MyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyProfileViewModel>(
        create: (_) {
          final MyProfileViewModel viewModel = MyProfileViewModel(
              userRepository:
                  UserRepository(remoteDataSource: MockDataSource()));
          return viewModel;
        },
        child: MyProfileView());
  }
}

class MyProfileView extends StatelessWidget {
  MyProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final MyProfileViewModel viewModel = context.read<MyProfileViewModel>();
    bool isLoading =
        context.watch<MyProfileViewModel>().status == Status.loading;

    if (isLoading) {
      viewModel.load();
      return const Center(child: Text("loading"));
    } else {
      return ListView(
        physics: const ScrollPhysics(),
        children: [
          MyMenuBar(),
          ProfileInfomation(),
          SizedBox(
            height: 16,
          ),
          TrackerView(),
          SizedBox(
            height: 16,
          ),
          BadgeView(),
        ],
      );
    }
  }
}

class BadgeView extends StatelessWidget {
  const BadgeView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    MyProfileViewModel viewModel = context.read<MyProfileViewModel>();
    List<BadgeClass.Badge> badge = viewModel.badge;
    void setClose(bool setClose) => viewModel.setIsClose(setClose);

    return InkWell(
      onTap: () async {
        context.go('/badge-edit');
        setClose(true);
      },
      child: Container(
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
      ),
    );
  }
}

class TrackerView extends StatelessWidget {
  const TrackerView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<int> tracker = context.read<MyProfileViewModel>().tracker;

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'total: ${tracker.length} 퀘스트 완료',
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        GridView.count(
          crossAxisCount: 12,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(60, (index) {
            return Container(
              color: Color.fromRGBO(35, 236, 116, tracker[index].toDouble()),
            );
          }),
        ),
      ],
    );
  }
}

class ProfileInfomation extends StatelessWidget {
  const ProfileInfomation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    MyProfileViewModel viewModel = context.read<MyProfileViewModel>();
    User user = viewModel.user;
    void setClose(bool setClose) => viewModel.setIsClose(setClose);

    String postCount = '0';
    String followerCount = '0';
    String followingCount = '0';

    if (user.postCount != Null) {
      postCount = user.postCount >= 999 ? "999+" : user.postCount.toString();
      followerCount =
          user.followerCount >= 999 ? "999+" : user.followerCount.toString();
      followingCount =
          user.followingCount >= 999 ? "999+" : user.followingCount.toString();
    }

    return Container(
      constraints: const BoxConstraints(maxWidth: 800),
      child: AspectRatio(
        aspectRatio: 1 / 0.2935779816513761,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // 가로로 정렬
          children: [
            // 프로필 사진
            InkWell(
              onTap: () async {
                bool? isLoad = await context.push<bool>(
                    '/profile-image-edit?imageurl=${user.imageUrl}');
                setClose(true);

                if (isLoad ?? false) {
                  debugPrint("동작! ${isLoad}");
                  viewModel.setStatusLoding();
                }
              },
              child: CircleAvatar(
                radius: 40, // 원하는 크기 설정
                backgroundImage: NetworkImage(user.imageUrl),
              ),
            ),
            // 게시물 수
            InkWell(
              onTap: () {},
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(postCount, style: const TextStyle(fontSize: 18)),
                  const Text('게시물', style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
            // 팔로워 수
            InkWell(
              onTap: () async {
                context.go('/my-follower-list');
                setClose(true);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(followerCount, style: const TextStyle(fontSize: 18)),
                  const Text('팔로워', style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
            // 팔로잉 수
            InkWell(
              onTap: () {
                context.go('/my-following-list');
                setClose(true);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(followingCount, style: const TextStyle(fontSize: 18)),
                  const Text('팔로잉', style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyMenuBar extends StatefulWidget {
  const MyMenuBar({Key? key}) : super(key: key);

  @override
  State<MyMenuBar> createState() => _MyMenuBarState();
}

class _MyMenuBarState extends State<MyMenuBar> {
  MenuController menu = MenuController();

  @override
  Widget build(BuildContext context) {
    bool isClose = context.watch<MyProfileViewModel>().isClose;
    void setClose(bool setClose) =>
        context.read<MyProfileViewModel>().setIsClose(setClose);

    return AppBar(
      title: const Text(
        "Username",
        style: TextStyle(fontSize: 18),
      ),
      actions: [
        SubmenuButton(
          controller: menu,
          onOpen: () => {
            //debugPrint("메뉴 열림! ${isClose}"),
            if (isClose)
              {
                menu.close(),
                setClose(false),
              }
          },
          alignmentOffset: const Offset(-275, 0),
          menuStyle: const MenuStyle(
              alignment: Alignment.bottomRight,
              backgroundColor:
                  MaterialStatePropertyAll(Color.fromARGB(255, 255, 255, 255)),
              side: MaterialStatePropertyAll(
                BorderSide(),
              )),
          menuChildren: [
            MenuItemButton(
              onPressed: () async {
                context.go('/account-disclosure');
                setClose(true);
                //debugPrint('isClose $isClose');
              },
              child: Container(
                width: 252,
                height: 48,
                padding: const EdgeInsets.fromLTRB(8, 15, 0, 0),
                margin: const EdgeInsets.all(0),
                child: const Text(
                  '계정 공개 범위',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const Divider(
              color: Colors.black,
            ),
            MenuItemButton(
              onPressed: () async {
                context.go('/myinterest');
                setClose(true);
              },
              child: Container(
                width: 252,
                height: 48,
                padding: const EdgeInsets.fromLTRB(8, 15, 0, 0),
                margin: const EdgeInsets.all(0),
                child: const Text(
                  '내 관심사 설정',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
          child: Container(
            width: 48,
            height: 48,
            child: const Icon(
              Icons.menu,
              size: 48,
            ),
          ),
        ),
      ],
    );
  }
}
