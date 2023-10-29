import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/dataSource/mock_data_source.dart';
import 'package:flutter_application_1/model/repository/user_repository.dart';
import 'package:flutter_application_1/page/common/Appbar.dart';
import 'package:flutter_application_1/page/my_profile/my_interest/my_interest_page_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../common/ExpanedBtn.dart';
import '../../common/Loding.dart';
import '../../common/Status.dart';

class MyInterestPage extends StatelessWidget {
  const MyInterestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyInterestViewModel>(
      create: (_) {
        final MyInterestViewModel viewModel = MyInterestViewModel(
            userRepository: UserRepository(remoteDataSource: MockDataSource()));
        return viewModel;
      },
      child: MyInterestView(
        context: context,
      ),
    );
  }
}

class MyInterestView extends StatelessWidget {
  final BuildContext context;

  const MyInterestView({
    super.key,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    final MyInterestViewModel viewModel = context.read<MyInterestViewModel>();

    bool isLoding =
        context.watch<MyInterestViewModel>().status == Status.loading;

    bool hasNewInterest =
        context.watch<MyInterestViewModel>().selectedInterest.isNotEmpty;

    if (isLoding) {
      viewModel.load();
      return Loading(
        context: context,
      );
    }

    return Scaffold(
      appBar: BackSpaceAppBar(
        key: UniqueKey(),
        appBar: AppBar(),
        title: "내 관심사 설정",
        isContextPopTrue: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                "관심사 선택",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "관심사를 추가해주세요.",
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            ImageCheckboxGrid(),
            ExpandedBtn(
              isShow: hasNewInterest,
              onPressFunc: viewModel.changeInterest,
              context: context,
              btnTitle: "완료",
            ),
          ],
        ),
      ),
    );
  }
}

class ImageCheckboxGrid extends StatelessWidget {
  final String imageUrl = 'https://picsum.photos/200/200';

  @override
  Widget build(BuildContext context) {
    List<String> interest = context.read<MyInterestViewModel>().interest;

    return GridView.count(
      crossAxisCount: 4, // 4열로 고정
      crossAxisSpacing: 4,

      mainAxisSpacing: 4,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: List.generate(
        interest.length,
        (index) {
          return ImageCheckbox(imageUrl: imageUrl, name: '${interest[index]}');
        },
      ),
    );
  }
}

class ImageCheckbox extends StatelessWidget {
  final String imageUrl;
  final String name;

  const ImageCheckbox({required this.imageUrl, required this.name});

  @override
  Widget build(BuildContext context) {
    MyInterestViewModel viewModel = context.watch<MyInterestViewModel>();
    Set<String> selectedInterest = viewModel.selectedInterest;
    bool isChecked = selectedInterest.contains(name);

    return GestureDetector(
      onTap: () {
        if (isChecked) {
          viewModel.removeIntrest(name);
          return;
        }
        viewModel.addInterest(name);
      },
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: 60,
                height: 60,
              ),
              if (isChecked)
                const Icon(
                  Icons.check,
                  color: Colors.black,
                  size: 50,
                ),
            ],
          ),
          Text(
            name,
            style: const TextStyle(
              fontSize: 16,
            ),
          )
        ],
      ),
    );
  }
}
