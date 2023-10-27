import 'package:provider/provider.dart';

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

class MyProfileView extends StatefulWidget {
  const MyProfileView({Key? key}) : super(key: key);

  @override
  State<MyProfileView> createState() => _MyProfileViewState();
}

class _MyProfileViewState extends State<MyProfileView> {
  late MyProfileViewModel viewModel;

  @override
  void initState() {
    super.initState();
    //viewModel = Provider.of<MyProfileViewModel>(context, listen: true);
  }

  @override
  Widget build(BuildContext context) {
    viewModel = Provider.of<MyProfileViewModel>(context, listen: true);

    if (viewModel.status != Status.loaded) {
      viewModel.load();
      return Center(child: Text("loading"));
    } else {
      for (int i = 0; i < viewModel.tracker.length; i++) {
        debugPrint(viewModel.tracker[i].toString());
      }

      return ListView(
        physics: const ScrollPhysics(),
        children: [
          MyMenuBar(),
          ProfileInfomation(),
          SizedBox(
            height: 16,
          ),
          TrackerView(),
          SizedBox.expand(
            child: FractionallySizedBox(
              heightFactor: 0.025,
            ),
          ), // 각 Expanded 위젯 간의 간격
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
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0), // GridView 주위에 16px의 패딩 설정
        child: GridView.count(
          crossAxisCount: 5,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: List.generate(10, (index) {
            return Container(
              margin: const EdgeInsets.all(4.0),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network('https://picsum.photos/200/200'),
              ),
            );
          }),
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
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'total: 306퀘스트 완료',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        GridView.count(
          crossAxisCount: 12,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          shrinkWrap: true, // 추가
          physics: NeverScrollableScrollPhysics(), // 추가
          children: List.generate(60, (index) {
            return Container(
              color: Color.fromRGBO(35, 236, 116, 1.0),
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
    return Container(
      constraints: BoxConstraints(maxWidth: 800),
      child: AspectRatio(
        aspectRatio: 1 / 0.2935779816513761,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // 가로로 정렬
          children: [
            // 프로필 사진
            InkWell(
              onTap: () {
                // 프로필 사진 클릭 시 실행할 작업
              },
              child: CircleAvatar(
                radius: 40, // 원하는 크기 설정
                backgroundImage: NetworkImage(''),
              ),
            ),
            // 게시물 수
            InkWell(
              onTap: () {},
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('100', style: TextStyle(fontSize: 18)),
                  Text('게시물', style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
            // 팔로워 수
            InkWell(
              onTap: () {},
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('999+', style: TextStyle(fontSize: 18)),
                  Text('팔로워', style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
            // 팔로잉 수
            InkWell(
              onTap: () {},
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('300', style: TextStyle(fontSize: 18)),
                  Text('팔로워', style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyMenuBar extends StatelessWidget {
  const MyMenuBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        "Username",
        style: TextStyle(fontSize: 18),
      ),
      actions: [
        SubmenuButton(
          alignmentOffset: Offset(-275, 0),
          menuStyle: const MenuStyle(
              alignment: Alignment.bottomRight,
              backgroundColor:
                  MaterialStatePropertyAll(Color.fromARGB(255, 255, 255, 255)),
              side: MaterialStatePropertyAll(
                BorderSide(),
              )),
          menuChildren: [
            MenuItemButton(
              onPressed: () {},
              child: Container(
                width: 252,
                height: 48,
                padding: EdgeInsets.fromLTRB(8, 15, 0, 0),
                margin: EdgeInsets.all(0),
                child: const Text(
                  '계정 공개 범위',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Divider(
              color: Colors.black,
            ),
            MenuItemButton(
              onPressed: () {},
              child: Container(
                width: 252,
                height: 48,
                padding: EdgeInsets.fromLTRB(8, 15, 0, 0),
                margin: EdgeInsets.all(0),
                child: const Text(
                  '계정 공개 범위',
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
