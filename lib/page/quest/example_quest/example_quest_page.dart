import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/class/post_image.dart';
import 'package:flutter_application_1/model/class/post_images.dart';
import 'package:flutter_application_1/model/repository/quest_repository.dart';
import 'package:flutter_application_1/page/common/Appbar.dart';
import 'package:flutter_application_1/page/common/Gap.dart';
import 'package:flutter_application_1/page/common/Loding.dart';
import 'package:flutter_application_1/page/common/Status.dart';
import 'package:flutter_application_1/page/common/post/post_bar.dart';
import 'package:flutter_application_1/page/common/post/post_image_view.dart';
import 'package:flutter_application_1/page/quest/example_quest/example_quest_page_model.dart';
import 'package:flutter_application_1/provider/error_status_provider.dart';
import 'package:provider/provider.dart';

class ExampleQuestPage extends StatelessWidget {
  final int questId;

  const ExampleQuestPage({
    super.key,
    required this.questId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ExampleQuestViewModel>(
      create: (_) {
        final ExampleQuestViewModel viewModel = ExampleQuestViewModel(
          errorStatusProvider: context.read<ErrorStatusProvider>(),
          questRepository: QuestRepository(),
          questId: questId,
        );
        return viewModel;
      },
      child: CreateGroupView(),
    );
  }
}

class CreateGroupView extends StatelessWidget {
  const CreateGroupView({
    Key? key,
  }) : super(key: key);

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 32;
    ExampleQuestViewModel viewModel = context.read<ExampleQuestViewModel>();
    Status status = context.watch<ExampleQuestViewModel>().status;

    if (status == Status.loading) {
      viewModel.load();
      return Loading(context: context);
    }

    String dscription = context.read<ExampleQuestViewModel>().description;
    PostImages exampleImages =
        context.watch<ExampleQuestViewModel>().exampleImages;
    List<PostImage> imageList = exampleImages.postImageList;
    int imageLength = imageList.length;
    int curImageIndex = exampleImages.index;

    void changeCurIdx(nextImageIndex) {
      viewModel.changeCurImageIndex(nextImageIndex);
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: BackSpaceAppBar(
          appBar: AppBar(),
          title: '퀘스트 예시 이미지',
          isContextPopTrue: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(dscription),
              Gap16(),
              PostImageView(
                width: width,
                imageList: imageList,
                imageLength: imageLength,
                changeCurIdx: changeCurIdx,
              ),
              Stack(
                children: [
                  SizedBox(
                    height: 48,
                    width: width,
                    child: DotsIndicator(
                      dotsCount: imageLength,
                      position: curImageIndex,
                    ),
                  ),
                  SizedBox(
                    height: 48,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
