import 'package:flutter/material.dart';
import 'package:flutter_application_1/page/my_profile/my_post/my_post_page_model.dart';

class AuthorProfile extends StatelessWidget {
  final String userImageUrl;
  final String username;
  final viewModel;
  final int postId;
  final int postIndex;
  final bool isClose;
  final Function clickAuthorTap;
  final Function setClose;

  const AuthorProfile({
    super.key,
    required this.userImageUrl,
    required this.username,
    required this.viewModel,
    required this.postId,
    required this.postIndex,
    required this.clickAuthorTap,
    required this.isClose,
    required this.setClose,
  });

  @override
  Widget build(BuildContext context) {
    MenuController menu = MenuController();

    return SizedBox(
      height: 48,
      child: Row(
        children: [
          InkWell(
            onTap: () {
              clickAuthorTap();
            },
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(userImageUrl),
                  radius: 24,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(username,
                      style: const TextStyle(
                        fontSize: 16,
                      )),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(),
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
            menuChildren: [
              MenuItemButton(
                onPressed: () async {
                  await viewModel.uninterestedPost(postId, postIndex);
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
              width: 48,
              height: 48,
              child: const Icon(
                Icons.more_horiz,
              ),
            ),
          )
        ],
      ),
    );
  }
}
