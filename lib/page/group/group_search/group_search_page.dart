import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/class/group.dart';
import 'package:flutter_application_1/model/class/interest.dart';
import 'package:flutter_application_1/model/repository/group_repository.dart';
import 'package:flutter_application_1/model/repository/user_repository.dart';

import 'package:flutter_application_1/page/common/Buttons.dart';
import 'package:flutter_application_1/page/common/Gap.dart';
import 'package:flutter_application_1/page/common/Status.dart';
import 'package:flutter_application_1/page/group/group_search/group_search_page_model.dart';
import 'package:flutter_application_1/provider/error_status_provider.dart';

import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class GroupSearchPage extends StatelessWidget {
  const GroupSearchPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupSearchViewModel>(
      create: (_) {
        final GroupSearchViewModel viewModel = GroupSearchViewModel(
          errorStatusProvider: context.read<ErrorStatusProvider>(),
          groupRepositoty: GroupRepositoty(),
          userRepository: UserRepository(),
        );
        return viewModel;
      },
      child: GroupSearchView(),
    );
  }
}

class GroupSearchView extends StatefulWidget {
  const GroupSearchView({
    Key? key,
  }) : super(key: key);

  @override
  State<GroupSearchView> createState() => _GroupSearchView();
}

class _GroupSearchView extends State<GroupSearchView> {
  Widget build(BuildContext context) {
    GroupSearchViewModel viewModel = context.read<GroupSearchViewModel>();
    PageController controller =
        context.watch<GroupSearchViewModel>().controller;
    Status status = context.watch<GroupSearchViewModel>().status;

    if (status == Status.loading) {
      viewModel.getInterests();
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
                child: InterestedGroupListView(),
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
    GroupSearchViewModel viewModel = context.watch<GroupSearchViewModel>();
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
    List<Interest> interest = context.read<GroupSearchViewModel>().interest;

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
    GroupSearchViewModel viewModel = context.watch<GroupSearchViewModel>();
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

class InterestedGroupListView extends StatelessWidget {
  const InterestedGroupListView({super.key});

  @override
  Widget build(BuildContext context) {
    GroupSearchViewModel viewModel = context.read<GroupSearchViewModel>();

    return PagedListView<int, Group>(
      pagingController: viewModel.pagingController,
      builderDelegate: PagedChildBuilderDelegate<Group>(
        itemBuilder: (context, user, index) => GroupItem(
          index: index,
        ),
      ),
    );
  }
}

class GroupItem extends StatelessWidget {
  final int index;

  const GroupItem({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    GroupSearchViewModel viewModel = context.read<GroupSearchViewModel>();
    Group group =
        context.watch<GroupSearchViewModel>().interestedGroupList[index];
    int groupId = group.groupId;
    String imageUrl = group.imageUrl;
    String groupName = group.name;
    int userCount = group.userCount;
    String description = group.description;
    bool isMember = group.isGroupMember;

    void btnClick() {
      if (isMember) {
        viewModel.quitGroup(groupId, index);
        return;
      }
      viewModel.joinGroup(groupId, index);
    }

    void moveGroupProfile() {
      context.push('/group-profile?groupId=$groupId');
    }

    return Column(
      children: [
        InkWell(
          onTap: () {
            moveGroupProfile();
          },
          child: SizedBox(
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        groupName,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        '멤버수: $userCount명',
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      Gap8(),
                      Text(
                        description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 80,
                  height: 28,
                  child: CommonBtn(
                    isPurple: !isMember,
                    onPressFunc: () {
                      btnClick();
                    },
                    context: context,
                    btnTitle: !isMember ? '가입' : '탈퇴',
                    fontSize: 16,
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }
}
