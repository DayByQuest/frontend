import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/model/repository/group_repository.dart';
import 'package:flutter_application_1/model/repository/post_repository.dart';
import 'package:flutter_application_1/model/repository/user_repository.dart';
import 'package:flutter_application_1/page/common/showSnackBarFunction.dart';
import 'package:flutter_application_1/page/create_post/create_post_page.dart';
import 'package:flutter_application_1/page/feed/feed_page.dart';
import 'package:flutter_application_1/page/group/groupPage.dart';
import 'package:flutter_application_1/page/search/search_page.dart';
import 'package:flutter_application_1/provider/error_status_provider.dart';
import 'package:flutter_application_1/provider/follow_status_provider.dart';
import 'package:flutter_application_1/provider/groupJoin_status_provider.dart';
import 'package:flutter_application_1/provider/postLike_status_provider%20copy.dart';
import 'package:flutter_application_1/routes/routes.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker_plus/image_picker_plus.dart';
import 'package:provider/provider.dart';
import './model/dataSource/remote_data_source.dart';
import './page/my_profile/my_profile_page.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  setUpGetIt();
  runApp(const MyApp());
}

GetIt getIt = GetIt.instance;

void setUpGetIt() {
  getIt.registerSingleton<RemoteDataSource>(RemoteDataSource());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ErrorStatusProvider>(
          create: (_) => ErrorStatusProvider(),
        ),
        ChangeNotifierProvider<FollowStatusProvider>(
          create: (context) => FollowStatusProvider(
            errorStatusProvider: context.read<ErrorStatusProvider>(),
            userRepository: UserRepository(),
          ),
        ),
        ChangeNotifierProvider<PostLikeStatusProvider>(
          create: (context) => PostLikeStatusProvider(
            errorStatusProvider: context.read<ErrorStatusProvider>(),
            postRepository: PostRepository(),
          ),
        ),
        ChangeNotifierProvider<GroupJoinStatusProvider>(
          create: (context) => GroupJoinStatusProvider(
            errorStatusProvider: context.read<ErrorStatusProvider>(),
            groupRepositoty: GroupRepositoty(),
          ),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyHomePage(),
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

    bool errorStatus = context.watch<ErrorStatusProvider>().errorStatus;
    String errorMessage = context.watch<ErrorStatusProvider>().errorMessage;

    if (errorStatus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showSnackBarFun(context, errorMessage);
        context.read<ErrorStatusProvider>().setErrorStatus(false, '');
      });
    }

    switch (_selectedIndex) {
      case 0:
        bodyWidget = FeedPage();
        break;
      case 1:
        bodyWidget = SafeArea(child: SearchPage());
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

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return Scaffold(
      body: bodyWidget,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.black,
            ),
            label: 'Feed',
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
    );
  }
}
