import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/repository/user_repository.dart';
import 'package:flutter_application_1/page/my_profile/my_follower_list/my_follower_list_page.dart';
import 'package:flutter_application_1/page/my_profile/my_following_list/my_following_list_page.dart';
import 'package:flutter_application_1/page/my_profile/my_interest/my_interest_page.dart';
import 'package:flutter_application_1/page/my_profile/my_post/my_post_page.dart';
import 'package:flutter_application_1/page/my_profile/profile_image_edit/profile_image_edit_page.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import './model/dataSource/remote_data_source.dart';
import './model/dataSource/mock_data_source.dart';
import './page/my_profile/my_profile_page.dart';
import 'page/my_profile/account_disclosure/account_disclosure_page.dart';

void main() {
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
            return ProfileImageEditPage();
          },
        ),
        GoRoute(
          path: 'my-post',
          builder: (context, state) {
            return MyPostPage();
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: (_selectedIndex != 4
            ? Center(child: Text("home"))
            : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: MyProfilePage(),
                ),
              )),
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
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
