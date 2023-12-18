import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/class/post_images.dart';
import 'package:flutter_application_1/model/repository/group_repository.dart';
import 'package:flutter_application_1/model/repository/user_repository.dart';
import 'package:flutter_application_1/page/common/Gap.dart';
import 'package:flutter_application_1/provider/error_status_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../../model/class/post.dart';
import '../../../model/class/post_image.dart';
import '../../../model/class/user.dart';
import '../../../model/dataSource/mock_data_source.dart';
import '../../../model/repository/post_repository.dart';
import '../../common/Appbar.dart';
import '../../common/post/Interested_post.dart';
import '../../common/post/uninterested_post.dart';
import 'group_member_page_model.dart';

class GroupMemberListPage extends StatelessWidget {
  final int groupId;

  const GroupMemberListPage({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) {
          return GroupMemberListViewModel(
            errorStatusProvider: context.read<ErrorStatusProvider>(),
            groupRepositoty: GroupRepositoty(),
            groupId: groupId,
          );
        },
        child: GroupMemberListView());
  }
}

class GroupMemberListView extends StatelessWidget {
  const GroupMemberListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    GroupMemberListViewModel viewModel =
        context.read<GroupMemberListViewModel>();

    return Scaffold(
      appBar: BackSpaceAppBar(
        appBar: AppBar(),
        title: "그룹원 목록 조회",
        isContextPopTrue: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            PagedListView<int, User>.separated(
              separatorBuilder: (context, index) {
                return Gap16();
              },
              shrinkWrap: true,
              primary: false,
              pagingController: viewModel.pagingController,
              builderDelegate: PagedChildBuilderDelegate<User>(
                itemBuilder: (context, post, index) => MemberItem(index: index),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MemberItem extends StatelessWidget {
  final int index;

  const MemberItem({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    GroupMemberListViewModel viewModel =
        context.read<GroupMemberListViewModel>();
    User member = viewModel.userList[index];
    String memberImageUrl = member.imageUrl;
    String memberUserName = member.username;
    String memberName = member.name;
    String memberRole = member.role!;
    String? myUserName = dotenv.env['USER_NAME'];

    void moveUserProfile() {
      if (myUserName! == memberUserName) {
        return;
      }

      context.push('/user-profile?username=$memberUserName');
    }

    return InkWell(
      onTap: () {
        moveUserProfile();
      },
      child: Row(
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: Image.network(
              memberImageUrl,
              fit: BoxFit.fill,
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
                  memberUserName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text(
                  memberRole,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }
}
