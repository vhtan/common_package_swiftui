import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/dialog/delete_dialog.dart';
import 'package:mvvm_cubit/common/widget/empty_widget.dart';
import 'package:mvvm_cubit/common/widget/primary_button.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/di.dart';
import 'package:mvvm_cubit/viewmodel/manager_role/manager_temp_form_handler/manager_temp_form_handler_cubit.dart';

class ManagerTempFormHandlerScreen extends StatefulWidget {
  final String id;

  const ManagerTempFormHandlerScreen({super.key, required this.id});

  @override
  State<StatefulWidget> createState() => _ManagerTempFormHandlerScreenState();
}

class _ManagerTempFormHandlerScreenState
    extends State<ManagerTempFormHandlerScreen> with WidgetsBindingObserver {
  final _cubit = ManagerTempFormHandlerCubit(repository: di());

  final FocusNode _nodeTextInput = FocusNode();
  KeyboardActionsConfig _keyboardActionsConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
      keyboardBarColor: Colors.grey[200],
      nextFocus: false,
      actions: [
        KeyboardActionsItem(
          focusNode: _nodeTextInput,
        ),
      ],
    );
  }

  PreferredSizeWidget get _appBar {
    return AppBar(
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: _buttons,
      ),
      leading: const BackButton(
        color: AppColors.white,
      ),
      automaticallyImplyLeading: true,
      title: const Text(
        "Cảnh báo",
        style: headLine1,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
      child: BlocConsumer<ManagerTempFormHandlerCubit, GenericCubitState>(
        listener: (context, state) {},
        builder: (context, state) {
          return BlocBuilder<ManagerTempFormHandlerCubit, GenericCubitState>(
            builder: (context, state) {
              return Scaffold(
                appBar: _appBar,
                backgroundColor: AppColors.white,
                body: KeyboardActions(
                  tapOutsideBehavior: TapOutsideBehavior.opaqueDismiss,
                  config: _keyboardActionsConfig(context),
                  child: _content,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget get _content {
    return const Column(
      children: [
        SizedBox(height: 20.0),
        SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              EmptyWidget(message: 'message'),
              SizedBox(height: 20.0),
            ],
          ),
        )
      ],
    );
  }

  Widget get _buttons {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Flexible(
            child: PrimaryButton(
              title: 'Đồng ý',
              buttonHeight: 50,
              onPressed: () {
                final dialog =
                    confirmDialog(context, 'Bạn có chắc chắn đồng ý cảnh báo?');
                dialog.then((value) {
                  if (value == true) {}
                });
              },
            ),
          ),
          const SizedBox(width: 20),
          Flexible(
            child: PrimaryButton(
              title: 'Từ chối',
              buttonHeight: 50,
              onPressed: () {
                final dialog = confirmDialog(
                    context, 'Bạn có chắc chắn từ chối cảnh báo?');
                dialog.then((value) {
                  if (value == true) {}
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
