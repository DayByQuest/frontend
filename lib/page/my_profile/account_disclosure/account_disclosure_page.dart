import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/dataSource/mock_data_source.dart';
import 'package:flutter_application_1/model/repository/user_repository.dart';
import 'package:flutter_application_1/page/my_profile/account_disclosure/account_disclosure_page_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../common/Appbar.dart';
import '../../common/Status.dart';

class AccountDisclosurePage extends StatelessWidget {
  const AccountDisclosurePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AccountDisclosureViewModel>(
      create: (_) {
        final AccountDisclosureViewModel viewModel = AccountDisclosureViewModel(
            userRepository: UserRepository(remoteDataSource: MockDataSource()));
        return viewModel;
      },
      child: AccountDisclosureView(
        context: context,
      ),
    );
  }
}

class AccountDisclosureView extends StatelessWidget {
  final BuildContext context;

  const AccountDisclosureView({
    super.key,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    final AccountDisclosureViewModel viewModel =
        context.read<AccountDisclosureViewModel>();

    bool isLoading =
        context.watch<AccountDisclosureViewModel>().status == Status.loading;

    if (isLoading) {
      viewModel.load();
      return const Center(
          child: Text(
        "loading",
        style: TextStyle(
          color: Colors.amber,
        ),
      ));
    }

    return Scaffold(
      appBar: BackSpaceAppBar(
        key: UniqueKey(),
        appBar: AppBar(),
        title: "계정 공개 범위",
        isContextPopTrue: true,
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: const Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '비공개 계정',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SwitchButton(),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "계정이 공개 상태이면 모든 사람에게 공개되고 비공개 상태라면 팔로워들에게만 공개가 됩니다.",
            ),
          ],
        ),
      ),
    );
  }
}

class SwitchButton extends StatelessWidget {
  const SwitchButton({super.key});

  @override
  Widget build(BuildContext context) {
    bool light = context.watch<AccountDisclosureViewModel>().isPrivate;
    final viewModel = context.read<AccountDisclosureViewModel>();

    return Switch(
      value: light,
      activeColor: Color(0x82589F),
      onChanged: (bool value) {
        viewModel.changeVisibility(value);
      },
    );
  }
}
