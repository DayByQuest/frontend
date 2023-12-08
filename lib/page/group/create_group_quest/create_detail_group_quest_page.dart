import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/class/interest.dart';
import 'package:flutter_application_1/model/repository/group_repository.dart';
import 'package:flutter_application_1/model/repository/user_repository.dart';
import 'package:flutter_application_1/page/common/Appbar.dart';
import 'package:flutter_application_1/page/common/Buttons.dart';
import 'package:flutter_application_1/page/common/Gap.dart';
import 'package:flutter_application_1/page/common/Loding.dart';
import 'package:flutter_application_1/page/common/Status.dart';
import 'package:flutter_application_1/page/group/create_group_quest/create_detail_group_quest_page_model.dart';
import 'package:flutter_application_1/provider/error_status_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CreateDetailGroupQuestPage extends StatelessWidget {
  final int questId;

  const CreateDetailGroupQuestPage({
    super.key,
    required this.questId,
  });

  @override // createDetailGroupQuestViewModel
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CreateDetailGroupQuestViewModel>(
      create: (_) {
        final CreateDetailGroupQuestViewModel viewModel =
            CreateDetailGroupQuestViewModel(
          errorStatusProvider: context.read<ErrorStatusProvider>(),
          groupRepositoty: GroupRepositoty(),
          userRepository: UserRepository(),
          questId: questId,
        );

        return viewModel;
      },
      child: CreateDetailGroupQuestPageView(),
    );
  }
}

class CreateDetailGroupQuestPageView extends StatelessWidget {
  const CreateDetailGroupQuestPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CreateDetailGroupQuestViewModel viewModel =
        context.read<CreateDetailGroupQuestViewModel>();
    bool isLoad = context.watch<CreateDetailGroupQuestViewModel>().isLoad;
    int questId = viewModel.questId;
    PageController controller =
        context.watch<CreateDetailGroupQuestViewModel>().controller;

    if (!isLoad) {
      viewModel.getLabelList();
      viewModel.getInterests();
      return Loading(context: context);
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          toolbarHeight: 48,
          centerTitle: true,
          title: const Text(
            "추가 사항 입력",
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              if (controller.page == 0) {
                context.pop(true);
                return;
              }

              controller.previousPage(
                duration: Duration(milliseconds: 500),
                curve: Curves.ease,
              );
            },
          ),
        ),
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
                child: TitleInput(),
              ),
              Center(
                child: DescriptionInput(),
              ),
              Center(
                child: MyDatePicker(),
              ),
              Center(
                child: LabelInput(),
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
    CreateDetailGroupQuestViewModel viewModel =
        context.watch<CreateDetailGroupQuestViewModel>();
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
        Text('퀘스트의 관심사를 추가해주세요.'),
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
    List<Interest> interest =
        context.read<CreateDetailGroupQuestViewModel>().interest;

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
    CreateDetailGroupQuestViewModel viewModel =
        context.watch<CreateDetailGroupQuestViewModel>();
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

class TitleInput extends StatefulWidget {
  TitleInput({
    super.key,
  });

  @override
  State<TitleInput> createState() => _TitleInputState();
}

class _TitleInputState extends State<TitleInput> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CreateDetailGroupQuestViewModel viewModel =
        context.read<CreateDetailGroupQuestViewModel>();
    String questTitle =
        context.watch<CreateDetailGroupQuestViewModel>().questTitle;
    bool isOverLength =
        context.watch<CreateDetailGroupQuestViewModel>().isOverLength;

    if (_textEditingController.text == "") {
      _textEditingController.text = questTitle;
    }

    bool hasTitle = 0 < questTitle.length && !isOverLength;

    void changeTitle(String input) {
      viewModel.setQuestTitle(input);
    }

    void moveNext() {
      if (!hasTitle) {
        return;
      }
      FocusScope.of(context).unfocus();
      viewModel.moveNextPage();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('퀘스트의 제목을 추가해주세요.'),
        Gap16(),
        Gap16(),
        TextField(
          controller: _textEditingController,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
            hintText: '제목을 입력해주세요.',
          ),
          onChanged: changeTitle,
        ),
        isOverLength
            ? Text(
                '퀘스트 제목은 15자를 넘길 수 없습니다.',
                style: TextStyle(
                  color: Colors.red,
                ),
              )
            : Container(),
        Gap16(),
        SizedBox(
          height: 48,
          child: CommonBtn(
            isPurple: hasTitle,
            onPressFunc: moveNext,
            context: context,
            btnTitle: '다음',
          ),
        )
      ],
    );
  }
}

class DescriptionInput extends StatefulWidget {
  const DescriptionInput({super.key});

  @override
  State<DescriptionInput> createState() => _DescriptionInputState();
}

class _DescriptionInputState extends State<DescriptionInput> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CreateDetailGroupQuestViewModel viewModel =
        context.read<CreateDetailGroupQuestViewModel>();
    String questCotent =
        context.watch<CreateDetailGroupQuestViewModel>().questContent;

    if (_textEditingController.text == "") {
      _textEditingController.text = questCotent;
    }

    bool hasCotent = 0 < questCotent.length;

    void changeContent(String input) {
      viewModel.setQuestContent(input);
    }

    void moveNext() {
      if (!hasCotent) {
        return;
      }
      FocusScope.of(context).unfocus();
      viewModel.moveNextPage();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('퀘스트의 설명을 추가해주세요.'),
        const Gap16(),
        const Gap16(),
        TextField(
          controller: _textEditingController,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.black,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
            hintText: '설명을 입력해주세요.',
          ),
          onChanged: (value) {
            changeContent(value);
          },
        ),
        const Gap16(),
        SizedBox(
          height: 48,
          child: CommonBtn(
            isPurple: hasCotent,
            onPressFunc: moveNext,
            context: context,
            btnTitle: '다음',
          ),
        )
      ],
    );
  }
}

class MyDatePicker extends StatefulWidget {
  const MyDatePicker({super.key});

  @override
  _MyDatePickerState createState() => _MyDatePickerState();
}

class _MyDatePickerState extends State<MyDatePicker> {
  DateTime selectedDate = DateTime.now();
  late String curTime = '미정';

  @override
  Widget build(BuildContext context) {
    CreateDetailGroupQuestViewModel viewModel =
        context.read<CreateDetailGroupQuestViewModel>();
    String expiredAt =
        context.watch<CreateDetailGroupQuestViewModel>().expiredAt;

    bool hasExpireAt = 0 < expiredAt.length;

    void moveNext() {
      if (!hasExpireAt) {
        return;
      }
      FocusScope.of(context).unfocus();
      viewModel.moveNextPage();
    }

    Future<void> _selectDate(BuildContext context) async {
      DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(), // 오늘 이후의 날짜만 선택 가능
        lastDate: DateTime(2101),
      );

      if (picked != null && picked != selectedDate) {
        viewModel.setExpiredAt(picked);
        setState(() {
          selectedDate = picked;
        });
      }
    }

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: () => _selectDate(context),
            child: Column(
              children: [
                const Text(
                  '퀘스트 기한 설정',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  expiredAt.length == 0 ? curTime : '${expiredAt} 까지',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Gap16(),
          Container(
            height: 48,
            child: CommonBtn(
              isPurple: hasExpireAt,
              onPressFunc: moveNext,
              context: context,
              btnTitle: '다음',
            ),
          ),
        ],
      ),
    );
  }
}

class LabelInput extends StatefulWidget {
  const LabelInput({super.key});

  @override
  State<LabelInput> createState() => _LabelInputState();
}

class _LabelInputState extends State<LabelInput> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 32;
    CreateDetailGroupQuestViewModel viewModel =
        context.read<CreateDetailGroupQuestViewModel>();
    Status status = context.watch<CreateDetailGroupQuestViewModel>().status;
    List<String> labelList =
        context.watch<CreateDetailGroupQuestViewModel>().labelList;
    bool isLoding = labelList.isEmpty;
    int selectLabelIndex =
        context.watch<CreateDetailGroupQuestViewModel>().selectLabelIndex;
    bool hasSelectLabel = viewModel.hasLabel();

    void createGroupQuest(BuildContext context) async {
      await viewModel.createGroupQuestDetail();
    }

    void setSelectLabel(String input) {
      viewModel.setLabel(input);
    }

    if (isLoding) {
      return Loading(context: context);
    }

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: labelList.length,
            separatorBuilder: (_, index) => const Divider(
              color: Colors.black,
            ),
            itemBuilder: (context, index) {
              String title = labelList[index];

              return LabelItem(
                index: index,
                labelTitle: title,
                selectLabelIndex: selectLabelIndex,
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
          child: TextField(
            controller: _textEditingController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Colors.black,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.black,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.black,
                ),
              ),
              hintText: '이미지에 해당되는 라벨이 없다면 직접 추가해주세요.',
            ),
            onChanged: (value) {
              setSelectLabel(value);
            },
          ),
        ),
        Align(
          alignment: AlignmentDirectional.bottomCenter,
          child: Container(
            height: 48,
            child: CommonBtn(
              isPurple: hasSelectLabel,
              onPressFunc: () => {
                createGroupQuest(context),
                context.pushReplacement('/main'),
              },
              context: context,
              btnTitle: '생성',
            ),
          ),
        )
      ],
    );
  }
}

class LabelItem extends StatelessWidget {
  final int index;
  final String labelTitle;
  final int selectLabelIndex;
  late bool isChecked = index == selectLabelIndex;

  LabelItem({
    super.key,
    required this.index,
    required this.labelTitle,
    required this.selectLabelIndex,
  });

  @override
  Widget build(BuildContext context) {
    CreateDetailGroupQuestViewModel viewModel =
        context.read<CreateDetailGroupQuestViewModel>();

    void onChange() {
      viewModel.setLabelIndex(isChecked, index);
    }

    return CheckboxListTile(
      value: isChecked,
      onChanged: (bool? value) {
        onChange();
      },
      title: Text(
        labelTitle,
        style: const TextStyle(
          fontSize: 16,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }
}
