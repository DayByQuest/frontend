import 'dart:io';

import 'package:card_swiper/card_swiper.dart';

import 'package:flutter_application_1/model/repository/post_repository.dart';
import 'package:flutter_application_1/page/common/Appbar.dart';
import 'package:flutter_application_1/page/common/Buttons.dart';
import 'package:flutter_application_1/page/create_post/create_post_page_model.dart';
import 'package:flutter_application_1/page/create_post/quest_list/quest_list_page.dart';
import 'package:flutter_application_1/provider/error_status_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker_plus/image_picker_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/Gap.dart';

class createPostPage extends StatelessWidget {
  final List<SelectedByte> selectedBytes;
  final SelectedImagesDetails details;

  const createPostPage({
    super.key,
    required this.details,
    required this.selectedBytes,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CreatePostViewModel>(
      create: (_) {
        CreatePostViewModel viewModel = CreatePostViewModel(
          errorStatusProvider: context.read<ErrorStatusProvider>(),
          postRepository: PostRepository(),
          details: details,
          selectedBytes: selectedBytes,
        );

        return viewModel;
      },
      child: const CreatePostView(),
    );
  }
}

class CreatePostView extends StatefulWidget {
  const CreatePostView({Key? key}) : super(key: key);

  @override
  State<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 32;
    CreatePostViewModel viewModel = context.read<CreatePostViewModel>();
    List<SelectedByte> selectedBytes = viewModel.selectedBytes;
    bool hasContent = 0 < context.watch<CreatePostViewModel>().content.length;
    String questTitle = context.watch<CreatePostViewModel>().questTitle;

    void setContent(String input) {
      viewModel.setContent(input);
    }

    void setQuest(int id, String title) {
      viewModel.setQuest(id, title);
    }

    void createPost() async {
      if (!hasContent) {
        return;
      }

      await viewModel.createPost();
      context.pop();
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: BackSpaceAppBar(
          appBar: AppBar(),
          title: '게시글 생성',
          isContextPopTrue: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              SizedBox(
                width: width,
                height: width,
                child: Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return Image.file(
                      selectedBytes[index].selectedFile,
                      fit: BoxFit.contain,
                    );
                  },
                  itemCount: selectedBytes.length,
                  loop: false,
                ),
              ),
              const Gap16(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '퀘스트 태그하기',
                    style: TextStyle(fontSize: 16),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return QuestListPage();
                          },
                        ),
                      ).then((value) {
                        if (value != false) {
                          String questTitle = value['questTitle'];
                          int questId = value['questId'];

                          setQuest(questId, questTitle);

                          debugPrint(
                              'questTitle: $questTitle, questId: $questId');
                        }
                      });
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        questTitle == "" ? Text('태그 없음') : Text(questTitle),
                        Gap8(),
                        Icon(Icons.arrow_forward),
                      ],
                    ),
                  )
                ],
              ),
              const Gap16(),
              TextField(
                controller: _textEditingController,
                maxLines: null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: '텍스트를 입력하세요...',
                ),
                onChanged: (value) {
                  setContent(value);
                },
              ),
              const Gap16(),
              SizedBox(
                height: 48,
                child: CommonBtn(
                  isPurple: hasContent,
                  onPressFunc: () async {
                    createPost();
                  },
                  context: context,
                  btnTitle: '생성',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
