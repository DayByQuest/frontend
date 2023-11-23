import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'my_group_list/my_group_list_page.dart';

class GroupPage extends StatelessWidget {
  const GroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 48,
          title: const TabBar(
            tabs: <Widget>[
              Tab(
                child: SizedBox(
                  width: 80,
                  child: Center(
                    child: Text(
                      '내 그룹',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              Tab(
                child: SizedBox(
                  width: 80,
                  child: Center(
                    child: Text(
                      '탐색',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            MyGroupListPage(),
            Center(
              child: Text("탐색이다"),
            ),
          ],
        ),
      ),
    );
  }
}
