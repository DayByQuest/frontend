import 'package:flutter/material.dart';
import 'package:flutter_application_1/page/common/Buttons.dart';
import 'package:flutter_application_1/page/post/detail_post_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';

class AuthorProfileView extends StatelessWidget {
  AuthorProfileView({
    super.key,
    required this.authorProfileImage,
    required this.authorUserName,
    required this.authorName,
    required this.isFollowing,
    required this.postId,
    required this.isClose,
    required this.clickFollowBtn,
    required this.uninterestedPost,
    required this.cancelUninterestedPost,
    required this.setClose,
  });

  final String authorProfileImage;
  final String authorUserName;
  final String authorName;
  final bool isFollowing;
  final int postId;
  final bool isClose;
  Function clickFollowBtn;
  Function uninterestedPost;
  Function cancelUninterestedPost;
  Function setClose;

  static String? USER_NAME = dotenv.env['USER_NAME'] ?? '';

  @override
  Widget build(BuildContext context) {
    MenuController menu = MenuController();
    bool isCurrentUserAuthor = authorUserName == USER_NAME;
    debugPrint(
        'isCurrentUserAuthor: $isCurrentUserAuthor authorName: $authorUserName USER_NAME: $USER_NAME');

    return InkWell(
      onTap: () {
        context.push('/user-profile?username=$authorUserName');
        setClose(true);
      },
      child: Row(
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: Image.network(
              authorProfileImage,
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
                  authorUserName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text(
                  authorName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          isCurrentUserAuthor
              ? Container()
              : SizedBox(
                  width: 78,
                  height: 28,
                  child: CommonBtn(
                    isPurple: !isFollowing,
                    onPressFunc: clickFollowBtn,
                    context: context,
                    btnTitle: isFollowing ? "팔로잉" : "팔로우",
                    fontSize: 16,
                  ),
                ),
          const SizedBox(
            height: 8,
          ),
          SubmenuButton(
            controller: menu,
            onOpen: () {
              if (isClose) {
                menu.close();
                setClose(false);
              }
            },
            alignmentOffset: const Offset(-275, 0),
            menuStyle: const MenuStyle(
                alignment: Alignment.bottomRight,
                backgroundColor: MaterialStatePropertyAll(
                    Color.fromARGB(255, 255, 255, 255)),
                side: MaterialStatePropertyAll(
                  BorderSide(),
                )),
            style: const ButtonStyle(
              padding: MaterialStatePropertyAll(
                EdgeInsets.all(0),
              ),
              minimumSize: MaterialStatePropertyAll(Size(28, 28)),
            ),
            menuChildren: [
              MenuItemButton(
                onPressed: () async {
                  await uninterestedPost();
                  showSnackBarFun(context, postId, cancelUninterestedPost);
                },
                child: Container(
                  width: 252,
                  height: 48,
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  margin: const EdgeInsets.all(0),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '이 게시물에 관심 없음',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Icon(Icons.block)
                    ],
                  ),
                ),
              ),
            ],
            child: Container(
              width: 28,
              height: 28,
              child: const Icon(
                Icons.more_horiz,
                size: 28,
              ),
            ),
          )
        ],
      ),
    );
  }
}
