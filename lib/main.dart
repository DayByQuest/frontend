import 'package:flutter/material.dart';
import 'package:flutter_application_1/page/create_post/create_post_page.dart';
import 'package:flutter_application_1/page/feed/feed_page.dart';
import 'package:flutter_application_1/page/group/create_group_quest/create_group_quest_page.dart';
import 'package:flutter_application_1/page/group/groupPage.dart';
import 'package:flutter_application_1/page/group/group_member_list/group_member_page.dart';
import 'package:flutter_application_1/page/group/group_post/group_post_page.dart';
import 'package:flutter_application_1/page/group/group_profile/group_profile_page.dart';

import 'package:flutter_application_1/page/my_profile/my_follower_list/my_follower_list_page.dart';
import 'package:flutter_application_1/page/my_profile/my_following_list/my_following_list_page.dart';
import 'package:flutter_application_1/page/my_profile/my_interest/my_interest_page.dart';
import 'package:flutter_application_1/page/my_profile/my_post/my_post_page.dart';
import 'package:flutter_application_1/page/my_profile/profile_image_edit/profile_image_edit_page.dart';
import 'package:flutter_application_1/page/post/detail_post_page.dart';
import 'package:flutter_application_1/page/profile/profile_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker_plus/image_picker_plus.dart';
import './model/dataSource/remote_data_source.dart';
import './page/my_profile/my_profile_page.dart';
import 'page/my_profile/account_disclosure/account_disclosure_page.dart';
import 'page/my_profile/my_badge_edit copy/my_badge_edit_page.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  setUpGetIt();
  runApp(const MyApp());
}

GetIt getIt = GetIt.instance;

void setUpGetIt() {
  getIt.registerSingleton<RemoteDataSource>(RemoteDataSource());
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const MyHomePage();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'account-disclosure',
          builder: (BuildContext context, GoRouterState state) {
            return AccountDisclosurePage();
          },
        ),
        GoRoute(
          path: 'myinterest',
          builder: (context, state) {
            return MyInterestPage();
          },
        ),
        GoRoute(
          path: 'profile-image-edit',
          builder: (context, state) {
            String url = state.uri.queryParameters['imageurl'] ?? 'null';
            return ProfileImageEditPage(
              imageUrl: url,
            );
          },
        ),
        GoRoute(
          path: 'my-post',
          builder: (context, state) {
            String username = state.uri.queryParameters['username'] ?? 'null';
            return MyPostPage(username: username);
          },
        ),
        GoRoute(
          path: 'my-follower-list',
          builder: (context, state) {
            return MyFollowerListPage();
          },
        ),
        GoRoute(
          path: 'my-following-list',
          builder: (context, state) {
            return MyFollowingListPage();
          },
        ),
        GoRoute(
          path: 'badge-edit',
          builder: (BuildContext context, GoRouterState state) {
            return MyBadgeEditPage();
          },
        ),
        GoRoute(
          path: 'user-profile',
          builder: (context, state) {
            String username = state.uri.queryParameters['username'] ?? 'null';
            return ProfilePage(
              username: username,
            );
          },
        ),
        GoRoute(
          path: 'detail',
          builder: (context, state) {
            String stringPostId = state.uri.queryParameters['postId'] ?? '0';
            int postId = int.parse(stringPostId);
            return DetailPage(
              postId: postId,
            );
          },
        ),
        GoRoute(
          path: 'create-group-quest',
          builder: (context, state) {
            int groupId = int.parse(state.uri.queryParameters['groupId']!) ?? 0;
            return CreateGroupQuestPage(
              groupId: groupId,
            );
          },
        ),
        GoRoute(
          path: 'group',
          builder: (context, state) {
            return GroupPage();
          },
        ),
        GoRoute(
          path: 'main',
          builder: (context, state) {
            return MyHomePage();
          },
        ),
        GoRoute(
          path: 'group-profile',
          builder: (context, state) {
            int groupId = int.parse(state.uri.queryParameters['groupId']!) ?? 0;
            return GroupProfilePage(groupId: groupId);
          },
        ),
        GoRoute(
          path: 'group-post',
          builder: (context, state) {
            int groupId = int.parse(state.uri.queryParameters['groupId']!) ?? 0;
            return GroupPostPage(groupId: groupId);
          },
        ),
        GoRoute(
          path: 'group-member-list',
          builder: (context, state) {
            int groupId = int.parse(state.uri.queryParameters['groupId']!) ?? 0;
            return GroupMemberListPage(groupId: groupId);
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  /// Constructs a [MyApp]
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  Future<void> addPost(context) async {
    ImagePickerPlus picker = ImagePickerPlus(context);
    SelectedImagesDetails? images;

    images = await picker.pickImage(
      source: ImageSource.gallery,
      galleryDisplaySettings: GalleryDisplaySettings(
        cropImage: true,
        maximumSelection: 5,
      ),
      multiImages: true,
    );

    if (images != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return createPostPage(
              selectedBytes: images!.selectedFiles,
              details: images,
            );
          },
        ),
      );
    }
  }

  void _onItemTapped(int index, BuildContext context) async {
    if (index != 2) {
      setState(() {
        _selectedIndex = index;
      });
    } else {
      addPost(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyWidget;

    switch (_selectedIndex) {
      case 0:
        bodyWidget = FeedPage();
        break;
      case 1:
        bodyWidget = Center(child: Text("Search"));
        break;
      case 2:
        bodyWidget = Container(); //CreatePost();
        break;
      case 3:
        bodyWidget = GroupPage();

        break;
      case 4:
        bodyWidget = const SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: MyProfilePage(),
          ),
        );
        break;
      default:
        bodyWidget = Container();
    }

    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: bodyWidget,
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.black,
              ),
              label: 'Home',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: Colors.black,
              ),
              label: 'Search',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add,
                color: Colors.black,
              ),
              label: 'Add',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.group,
                color: Colors.black,
              ),
              label: 'Group',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: Colors.black,
              ),
              label: 'Person',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: (index) {
            _onItemTapped(index, context);
          },
        ),
      ),
    );
  }
}
