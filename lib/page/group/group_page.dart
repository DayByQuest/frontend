import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/repository/group_repository.dart';
import 'package:flutter_application_1/page/common/Appbar.dart';
import 'package:flutter_application_1/page/common/Buttons.dart';
import 'package:flutter_application_1/page/common/Gap.dart';
import 'package:flutter_application_1/page/group/group_page_model.dart';
import 'package:flutter_application_1/page/group/create_detail_group_quest_page.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker_plus/image_picker_plus.dart';
import 'package:provider/provider.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({Key? key}) : super(key: key);
  @override
  State<GroupPage> createState() => _GroupPage();
}

class _GroupPage extends State<GroupPage> {
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

      if (images == null || images.selectedFiles.length != 3) {
        return;
      }

      if (images != null && images.selectedFiles.length == 3) {
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (BuildContext context) {
        //       return DescribeImagesPage(
        //         selectedBytes: images!.selectedFiles,
        //         details: images,
        //       );
        //     },
        //   ),
        // );

        Navigator.push<void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) {
              return DescribeImagesPage(
                selectedBytes: images!.selectedFiles,
                details: images,
              );
            },
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('이미지 선택'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                '퀘스트를 수행했음을 검증할 수 있는 성공 이미지를 최대 3장 넣어주세요!',
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

  const DescribeImagesPage({
    super.key,
    required this.details,
    required this.selectedBytes,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DescribeImagesViewModel>(
      create: (_) {
        final DescribeImagesViewModel viewModel = DescribeImagesViewModel(
            groupRepositoty: GroupRepositoty(),
            details: details,
            selectedBytes: selectedBytes);
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

    bool canCreate =
        0 < context.watch<DescribeImagesViewModel>().description.length;

    void setDescription(String input) {
      viewModel.setDescription(input);
    }

    Future<void> createGroupQuest() async {
      int questId = await viewModel.createGroupQuest();

      if (questId != -1) {
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (BuildContext context) {
        //       return CreateDetailGroupQuestPage(questId: questId);
        //     },
        //   ),
        // );

        Navigator.push<void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) {
              return CreateDetailGroupQuestPage(questId: questId);
            },
          ),
        );
      }
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("이미지 설명 추가"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              TextField(
                controller: _textEditingController,
                maxLines: null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: '성공 이미지에 대한 설명을 작성해주세요!',
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
