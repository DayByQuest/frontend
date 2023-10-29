import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/dataSource/mock_data_source.dart';
import 'package:flutter_application_1/model/repository/user_repository.dart';
import 'package:flutter_application_1/page/common/Appbar.dart';
import 'package:flutter_application_1/page/my_profile/profile_image_edit/profile_image_edit_page_model.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../common/Loding.dart';
import '../../common/Status.dart';

class ProfileImageEditPage extends StatelessWidget {
  final String imageUrl;

  const ProfileImageEditPage({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfileImageEditViewModel>(
      create: (_) {
        final ProfileImageEditViewModel viewModel = ProfileImageEditViewModel(
            userRepository: UserRepository(remoteDataSource: MockDataSource()));
        viewModel.load(imageUrl);
        return viewModel;
      },
      child: ProfileImageEditView(
        context: context,
        imageUrl: imageUrl,
      ),
    );
  }
}

class ProfileImageEditView extends StatelessWidget {
  const ProfileImageEditView({
    super.key,
    required this.imageUrl,
    required this.context,
  });

  final String imageUrl;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final ProfileImageEditViewModel viewModel =
        context.read<ProfileImageEditViewModel>();

    bool isLoding =
        context.watch<ProfileImageEditViewModel>().status == Status.loading;

    if (isLoding) {
      return Loading(
        context: context,
      );
    }

    return Scaffold(
        appBar: BackSpaceAppBar(
          key: UniqueKey(),
          appBar: AppBar(),
          title: "프로필 사진 변경",
          isContextPopTrue: false,
        ),
        body: const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            children: [
              Text(
                '다른 회원님들이 회원님을 알아볼 수 있도록 프로필 사진을 추가해주세요.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 16,
              ),
              ImageSelectWidget(),
            ],
          ),
        ));
  }
}

class ImageSelectWidget extends StatelessWidget {
  const ImageSelectWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ProfileImageEditViewModel viewModel =
        context.read<ProfileImageEditViewModel>();
    bool hasImage = context.watch<ProfileImageEditViewModel>().image != null;
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
              ? () async => {
                    await viewModel.changeProfileImage(),
                    context.pop(true),
                  }
              : () {},
          context: context,
          btnTitle: "완료",
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
    final viewModel = context.watch<ProfileImageEditViewModel>();
    XFile? image = viewModel.image;
    String imageUrl = viewModel.currentImageUrl;

    //debugPrint(image.toString());

    return CircleAvatar(
      backgroundImage: image != null
          ? FileImage(File(image!.path)) as ImageProvider<Object>
          : NetworkImage(imageUrl),
      radius: 100,
    );
  }
}

class CommonBtn extends StatelessWidget {
  const CommonBtn({
    super.key,
    required this.isPurple,
    required this.onPressFunc,
    required this.context,
    required this.btnTitle,
  });

  final String btnTitle;
  final bool isPurple;
  final Function onPressFunc;
  final BuildContext context;

  @override
  Widget build(BuildContext _) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all(
                const Size.fromHeight(48),
              ),
              shape: MaterialStateProperty.all(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
              side: MaterialStateProperty.all(
                BorderSide(
                  color: isPurple ? Color(0xFF82589F) : Colors.black,
                ),
              ),
              backgroundColor: MaterialStateProperty.all(
                isPurple ? Color(0xFFD6A2E8) : null,
              ),
            ),
            onPressed: () async {
              onPressFunc();
            },
            child: Text(
              btnTitle,
              style: TextStyle(
                fontSize: 22,
                color: isPurple ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
