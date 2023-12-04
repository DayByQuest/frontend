import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/model/class/interest.dart';
import 'package:flutter_application_1/model/repository/group_repository.dart';
import 'package:flutter_application_1/model/repository/user_repository.dart';
import 'package:flutter_application_1/page/common/Appbar.dart';

import 'package:flutter_application_1/page/common/Buttons.dart';
import 'package:flutter_application_1/page/common/Gap.dart';
import 'package:flutter_application_1/page/common/Status.dart';
import 'package:flutter_application_1/page/group/create_group/create_group_page_model.dart';
import 'package:flutter_application_1/page/group/create_group_quest/create_detail_group_quest_page.dart';
import 'package:flutter_application_1/provider/error_status_provider.dart';

import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_plus/image_picker_plus.dart';
import 'package:provider/provider.dart';

class CreateGroupPage extends StatelessWidget {
  const CreateGroupPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CreateGroupViewModel>(
      create: (_) {
        final CreateGroupViewModel viewModel = CreateGroupViewModel(
          errorStatusProvider: context.read<ErrorStatusProvider>(),
          groupRepositoty: GroupRepositoty(),
          userRepository: UserRepository(),
        );
        return viewModel;
      },
      child: CreateGroupView(),
    );
  }
}

class CreateGroupView extends StatefulWidget {
  const CreateGroupView({
    Key? key,
  }) : super(key: key);

  @override
  State<CreateGroupView> createState() => _CreateGroupView();
}

class _CreateGroupView extends State<CreateGroupView> {
  Widget build(BuildContext context) {
    CreateGroupViewModel viewModel = context.read<CreateGroupViewModel>();
    PageController controller =
        context.watch<CreateGroupViewModel>().controller;
    Status status = context.watch<CreateGroupViewModel>().status;

    if (status == Status.loading) {
      viewModel.getInterests();
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 48,
          centerTitle: true,
          title: const Text(
            "추가 사항 입력",
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              if (controller.page != 0) {
                controller.previousPage(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.ease,
                );
                FocusScope.of(context).unfocus();
                return;
              }
              context.pop();
              return;
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: PageView(
            controller: controller,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              Center(
                child: InterestInput(),
              ),
              Center(
                child: TitleInput(),
              ),
              Center(
                child: ImageInput(),
              ),
              Center(
                child: DescriptionInput(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InterestInput extends StatelessWidget {
  const InterestInput({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 32;
    CreateGroupViewModel viewModel = context.watch<CreateGroupViewModel>();
    String selectInterest = viewModel.selectInterest;
    bool hasSelectedInterst = 0 < selectInterest.length;

    void moveNext() {
      if (!hasSelectedInterst) {
        return;
      }

      FocusScope.of(context).unfocus();
      viewModel.moveNextPage();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: width * 0.62,
              child: const Text(
                '그룹에 맞는 관심사를 한개 골라주세요.',
                style: TextStyle(
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        Gap16(),
        ImageCheckboxGrid(),
        Gap16(),
        SizedBox(
          height: 48,
          child: CommonBtn(
            isPurple: hasSelectedInterst,
            onPressFunc: moveNext,
            context: context,
            btnTitle: '다음',
          ),
        )
      ],
    );
  }
}

class ImageCheckboxGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Interest> interest = context.read<CreateGroupViewModel>().interest;

    return GridView.count(
      crossAxisCount: 4, // 4열로 고정
      crossAxisSpacing: 4,

      mainAxisSpacing: 4,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: List.generate(
        interest.length,
        (index) {
          return ImageCheckbox(
              imageUrl: interest[index].imageUrl,
              name: '${interest[index].name}');
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
    CreateGroupViewModel viewModel = context.watch<CreateGroupViewModel>();
    String selectInterest = viewModel.selectInterest;
    bool isChecked = name == selectInterest;

    void setInterest() {
      viewModel.setInterest(name);
    }

    return GestureDetector(
      onTap: () {
        setInterest();
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

class TitleInput extends StatefulWidget {
  TitleInput({
    super.key,
  });

  @override
  State<TitleInput> createState() => _TitleInputState();
}

class _TitleInputState extends State<TitleInput> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CreateGroupViewModel viewModel = context.read<CreateGroupViewModel>();
    String groupName = context.watch<CreateGroupViewModel>().groupName;
    bool isDuplicateGroupName =
        context.watch<CreateGroupViewModel>().isDuplicateGroupName;

    if (_textEditingController.text == "") {
      _textEditingController.text = groupName;
    }

    bool hasTitle = 0 < groupName.length && !isDuplicateGroupName;

    void changeGroupName(String input) {
      viewModel.setGroupName(input);
    }

    void moveNext() {
      if (!hasTitle) {
        return;
      }
      FocusScope.of(context).unfocus();
      viewModel.moveNextPage();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '그룹만의 고유한 이름을 만들어주세요.',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        Gap16(),
        Gap16(),
        TextField(
          controller: _textEditingController,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
            hintText: '제목을 입력해주세요.',
          ),
          onChanged: changeGroupName,
        ),
        isDuplicateGroupName
            ? Text(
                '이미 존재하는 그룹 이름입니다.',
                style: TextStyle(
                  color: Colors.red,
                ),
              )
            : Container(),
        Gap16(),
        SizedBox(
          height: 48,
          child: CommonBtn(
            isPurple: hasTitle,
            onPressFunc: moveNext,
            context: context,
            btnTitle: '다음',
          ),
        )
      ],
    );
  }
}

class ImageInput extends StatelessWidget {
  const ImageInput({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          '다른 회원님들이 그룹을 알아볼 수 있도록 프로필 사진을 추가해주세요.',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(
          height: 16,
        ),
        ImageSelectWidget(),
      ],
    );
  }
}

class ImageSelectWidget extends StatelessWidget {
  const ImageSelectWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    CreateGroupViewModel viewModel = context.read<CreateGroupViewModel>();
    bool hasImage = context.watch<CreateGroupViewModel>().image != null;
    Function getImage = viewModel.getImage;
    return Column(
      children: [
        Container(
          height: 200,
          width: 200,
          child: ImageCircleAvartar(),
        ),
        const SizedBox(
          height: 16,
        ),
        CommonBtn(
          isPurple: false,
          onPressFunc: () async => {
            await getImage(),
          },
          context: context,
          btnTitle: "사진변경",
        ),
        const SizedBox(
          height: 16,
        ),
        CommonBtn(
          isPurple: hasImage,
          onPressFunc: hasImage
              ? () async {
                  if (!hasImage) {
                    return;
                  }

                  viewModel.moveNextPage();
                }
              : () {},
          context: context,
          btnTitle: "다음",
        ),
      ],
    );
  }
}

class ImageCircleAvartar extends StatelessWidget {
  ImageCircleAvartar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CreateGroupViewModel>();
    XFile? image = viewModel.image;

    //debugPrint(image.toString());

    return CircleAvatar(
      backgroundImage: image != null
          ? FileImage(File(image!.path)) as ImageProvider<Object>
          : null,
      radius: 100,
    );
  }
}

class DescriptionInput extends StatefulWidget {
  const DescriptionInput({super.key});

  @override
  State<DescriptionInput> createState() => _DescriptionInputState();
}

class _DescriptionInputState extends State<DescriptionInput> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CreateGroupViewModel viewModel = context.read<CreateGroupViewModel>();
    String groupDescription =
        context.watch<CreateGroupViewModel>().groupDescription;

    if (_textEditingController.text == "") {
      _textEditingController.text = groupDescription;
    }

    bool hasCotent = 0 < groupDescription.length;

    void changeContent(String input) {
      viewModel.setGroupDescription(input);
    }

    void moveNext() async {
      if (!hasCotent) {
        return;
      }
      FocusScope.of(context).unfocus();
      await viewModel.createGroup();
      context.pop(true);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '그룹을 간단하게 한두줄로 설명해주세요!',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        const Gap16(),
        const Gap16(),
        TextField(
          controller: _textEditingController,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.black,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
            hintText: '설명을 입력해주세요.',
          ),
          onChanged: (value) {
            changeContent(value);
          },
        ),
        const Gap16(),
        SizedBox(
          height: 48,
          child: CommonBtn(
            isPurple: hasCotent,
            onPressFunc: moveNext,
            context: context,
            btnTitle: '다음',
          ),
        )
      ],
    );
  }
}
