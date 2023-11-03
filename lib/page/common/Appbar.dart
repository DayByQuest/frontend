import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BackSpaceAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BackSpaceAppBar(
      {super.key,
      required this.appBar,
      required this.title,
      required this.isContextPopTrue});

  final AppBar appBar;
  final String title;
  final bool isContextPopTrue;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      toolbarHeight: 48,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.black,
        ), // 뒤로가기 아이콘
        onPressed: () {
          context.pop(isContextPopTrue);
        },
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.black,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}
