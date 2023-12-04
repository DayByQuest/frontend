import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/dataSource/mock_data_source.dart';
import 'package:flutter_application_1/model/repository/user_repository.dart';
import 'package:flutter_application_1/page/common/Gap.dart';
import 'package:flutter_application_1/page/common/Loding.dart';
import 'package:flutter_application_1/page/my_profile/account_disclosure/account_disclosure_page_model.dart';
import 'package:flutter_application_1/provider/error_status_provider.dart';
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
          errorStatusProvider: context.read<ErrorStatusProvider>(),
          userRepository: UserRepository(),
        );
        return viewModel;
      },
      child: AccountDisclosureView(),
    );
  }
}

class AccountDisclosureView extends StatelessWidget {
  const AccountDisclosureView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final AccountDisclosureViewModel viewModel =
        context.read<AccountDisclosureViewModel>();

    bool isLoading =
        context.watch<AccountDisclosureViewModel>().status == Status.loading;

    if (isLoading) {
      viewModel.load();
      return Loading(context: context);
    }

    return Scaffold(
      appBar: BackSpaceAppBar(
        appBar: AppBar(),
        title: "계정 공개 범위",
        isContextPopTrue: true,
      ),
      body: const Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
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
            Gap16(),
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
    final viewModel = context.read<AccountDisclosureViewModel>();
    bool light = context.watch<AccountDisclosureViewModel>().isPrivate;

    return Switch(
      value: light,
      activeColor: const Color(0x82589F),
      onChanged: (bool value) {
        viewModel.changeVisibility(value);
      },
    );
  }
}
