import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/repository/group_repository.dart';
import 'package:flutter_application_1/page/common/Appbar.dart';
import 'package:flutter_application_1/page/common/Buttons.dart';
import 'package:flutter_application_1/page/common/Gap.dart';
import 'package:flutter_application_1/page/common/Loding.dart';
import 'package:flutter_application_1/page/common/Status.dart';
import 'package:flutter_application_1/page/group/create_group_quest/create_detail_group_quest_page.dart';
import 'package:flutter_application_1/page/group/create_group_quest/create_group_quest_page_model.dart';
import 'package:flutter_application_1/provider/error_status_provider.dart';

import 'package:go_router/go_router.dart';
import 'package:image_picker_plus/image_picker_plus.dart';
import 'package:provider/provider.dart';

class CreateGroupQuestPage extends StatefulWidget {
  final int groupId;

  const CreateGroupQuestPage({
    Key? key,
    required this.groupId,
  }) : super(key: key);
  @override
  State<CreateGroupQuestPage> createState() => _CreateGroupQuestPage();
}

class _CreateGroupQuestPage extends State<CreateGroupQuestPage> {
  @override
  Widget build(BuildContext context) {
    Future<void> selectImageFile() async {
      ImagePickerPlus picker = ImagePickerPlus(context);
      SelectedImagesDetails? images;

      images = await picker.pickImage(
        source: ImageSource.gallery,
        galleryDisplaySettings: GalleryDisplaySettings(
          cropImage: true,
          maximumSelection: 3,
        ),
        multiImages: true,
      );

      // alert 추가
      if (images == null || images.selectedFiles.length != 3) {
        return;
      }

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return DescribeImagesPage(
              selectedBytes: images!.selectedFiles,
              details: images,
              groupId: widget.groupId,
            );
          },
        ),
      );
    }

    return Scaffold(
      appBar: BackSpaceAppBar(
        appBar: AppBar(),
        title: '이미지 선택',
        isContextPopTrue: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                '퀘스트를 수행했음을 검증할 수 있는 성공 이미지를 3장 넣어주세요!',
                style: TextStyle(fontSize: 16),
              ),
              Gap16(),
              SizedBox(
                height: 48,
                child: CommonBtn(
                  isPurple: true,
                  onPressFunc: () async {
                    await selectImageFile();
                  },
                  context: context,
                  btnTitle: '이미지 선택',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DescribeImagesPage extends StatelessWidget {
  final List<SelectedByte> selectedBytes;
  final SelectedImagesDetails details;
  final int groupId;

  const DescribeImagesPage({
    super.key,
    required this.details,
    required this.selectedBytes,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DescribeImagesViewModel>(
      create: (_) {
        final DescribeImagesViewModel viewModel = DescribeImagesViewModel(
          errorStatusProvider: context.read<ErrorStatusProvider>(),
          groupRepositoty: GroupRepositoty(),
          details: details,
          selectedBytes: selectedBytes,
          groupId: groupId,
        );
        return viewModel;
      },
      child: DescribeImages(
        selectedBytes: selectedBytes,
        details: details,
      ),
    );
  }
}

class DescribeImages extends StatefulWidget {
  final List<SelectedByte> selectedBytes;
  final SelectedImagesDetails details;

  const DescribeImages({
    Key? key,
    required this.details,
    required this.selectedBytes,
  }) : super(key: key);

  @override
  State<DescribeImages> createState() => _DescribeImagesState();
}

class _DescribeImagesState extends State<DescribeImages> {
  TextEditingController _textEditingController = TextEditingController();
  String description = '';

  Widget build(BuildContext context) {
    int imageLength = widget.selectedBytes.length;
    double width = MediaQuery.of(context).size.width - 32;
    DescribeImagesViewModel viewModel = context.read<DescribeImagesViewModel>();
    bool isLoading =
        context.watch<DescribeImagesViewModel>().status == Status.loading;

    bool canCreate =
        context.watch<DescribeImagesViewModel>().description.isNotEmpty;

    void setDescription(String input) {
      viewModel.setDescription(input);
    }

    Future<void> createGroupQuest() async {
      int questId = await viewModel.createGroupQuest();

      if (questId != -1) {
        context.push('/create-detail-group-quest?questId=$questId');
      }
    }

    if (isLoading) {
      return Scaffold(
        appBar: BackSpaceAppBar(
          appBar: AppBar(),
          title: '이미지 설명 추가',
          isContextPopTrue: true,
        ),
        body: Loading(context: context),
      );
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: BackSpaceAppBar(
          appBar: AppBar(),
          title: '이미지 설명 추가',
          isContextPopTrue: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              TextField(
                controller: _textEditingController,
                maxLines: 3,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText:
                      '성공 이미지에 대한 설명을 작성해주세요!\n 단 명사형으로 작성해주세요! ex) 생성을 훔치는 고양이',
                ),
                onSubmitted: (value) {},
                onChanged: (value) {
                  setDescription(value);
                  setState(() {
                    description = value;
                    //debugPrint('description: $description');
                  });
                },
              ),
              const Gap16(),
              SizedBox(
                width: width,
                height: width,
                child: Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return Image.file(
                      widget.selectedBytes[index].selectedFile,
                      fit: BoxFit.contain,
                    );
                  },
                  itemCount: imageLength,
                  loop: false,
                ),
              ),
              const Gap16(),
              SizedBox(
                height: 48,
                child: CommonBtn(
                  isPurple: canCreate,
                  onPressFunc: createGroupQuest,
                  context: context,
                  btnTitle: '다음',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
