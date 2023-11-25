import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/repository/group_repository.dart';
import 'package:flutter_application_1/page/common/Appbar.dart';
import 'package:flutter_application_1/page/common/Buttons.dart';
import 'package:flutter_application_1/page/common/Gap.dart';
import 'package:flutter_application_1/page/group/create_group_quest/create_detail_group_quest_page.dart';
import 'package:flutter_application_1/page/group/create_group_quest/create_group_quest_page_model.dart';

import 'package:go_router/go_router.dart';
import 'package:image_picker_plus/image_picker_plus.dart';
import 'package:provider/provider.dart';

class CreateGroupPage extends StatelessWidget {
  const CreateGroupPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DescribeImagesViewModel>(
      create: (_) {
        final DescribeImagesViewModel viewModel = DescribeImagesViewModel(
          groupRepositoty: GroupRepositoty(),
          details: details,
          selectedBytes: selectedBytes,
          groupId: groupId,
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
    return Scaffold(
      body: BackSpaceAppBar(
        appBar: AppBar(),
        title: '그룹 생성',
        isContextPopTrue: false,
      ),
    );
  }
}
