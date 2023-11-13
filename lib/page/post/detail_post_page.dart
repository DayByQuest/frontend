import 'package:flutter/material.dart';
import 'package:flutter_application_1/page/common/Appbar.dart';

class DetailPage extends StatelessWidget {
  final int postId;

  const DetailPage({
    super.key,
    required this.postId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackSpaceAppBar(
          appBar: AppBar(), title: '상세페이지', isContextPopTrue: true),
      body: Text('postId: $postId'),
    );
  }
}
