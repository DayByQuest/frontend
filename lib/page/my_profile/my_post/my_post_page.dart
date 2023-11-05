import 'package:flutter/material.dart';

class MyPostPage extends StatelessWidget {
  const MyPostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // 뒤로가기 아이콘
          onPressed: () {
            debugPrint('동작!');
            Navigator.pop(context);
          },
        ),
        title: const Text(
          '내 게시물',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate back to first route when tapped.
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}
