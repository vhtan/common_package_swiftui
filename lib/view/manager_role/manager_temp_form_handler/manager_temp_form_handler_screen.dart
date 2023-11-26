import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/dialog/delete_dialog.dart';
import 'package:mvvm_cubit/common/widget/primary_button.dart';
import 'package:mvvm_cubit/common/widget/text_input.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/data/model/temp_form_history/temp_form_history_response.dart';
import 'package:mvvm_cubit/data/request/temp_form_process/temp_form_process_request.dart';
import 'package:mvvm_cubit/data/request/warning_process/warning_process_request.dart';
import 'package:mvvm_cubit/di.dart';
import 'package:mvvm_cubit/viewmodel/manager_role/manager_temp_form_handler/manager_temp_form_handler_cubit.dart';

class ManagerTempFormHandlerScreen extends StatefulWidget {
  final TempFormHistoryResponse tempForm;

  const ManagerTempFormHandlerScreen({
    super.key,
    required this.tempForm,
  });

  @override
  State<StatefulWidget> createState() => _ManagerTempFormHandlerScreenState();
}

class _ManagerTempFormHandlerScreenState
    extends State<ManagerTempFormHandlerScreen> with WidgetsBindingObserver {
  final _cubit = ManagerTempFormHandlerCubit(repository: di());
  final double _spacing = 10;
  final _oCcy = NumberFormat("#,##0", "vi_VN");
  final _commentController = TextEditingController();

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
        "PYC tạm",
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
        listener: (context, state) {
          if (state is DidProcessTempFormSuccess) {
            Navigator.pop(context, true);
          }
        },
        builder: (context, state) {
          return BlocBuilder<ManagerTempFormHandlerCubit, GenericCubitState>(
            builder: (context, state) {
              return Scaffold(
                appBar: _appBar,
                backgroundColor: AppColors.white,
                bottomNavigationBar: Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: _sendMessage,
                ),
                body: KeyboardActions(
                  tapOutsideBehavior: TapOutsideBehavior.opaqueDismiss,
                  config: _keyboardActionsConfig(context),
                  child: _content(widget.tempForm),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _content(TempFormHistoryResponse tempForm) {
    return Column(
      children: [
        const SizedBox(height: 20.0),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Mã PYC tạm: ${tempForm.code ?? ''}',
                      style: textDefault,
                    )
                  ],
                ),
                SizedBox(height: _spacing),
                const Text(
                  'Mục đích di chuyển:',
                  style: textDefaultLight,
                ),
                Text(
                  tempForm.purpose?.name?.decodeHtml ?? '',
                  maxLines: 3,
                  style: textDefault,
                ),
                SizedBox(height: _spacing),
                const Text(
                  'Điểm dừng:',
                  style: textDefaultLight,
                ),
                Text(
                  tempForm.address?.address?.decodeHtml ?? '',
                  style: textDefault,
                  maxLines: 4,
                ),
                SizedBox(height: _spacing),
                const Text(
                  'Số tiền',
                  style: textDefaultLight,
                ),
                Text(
                  _oCcy.format(tempForm.quantity),
                  style: textDefault,
                ),
                SizedBox(height: _spacing),
                const Text(
                  'Loại tiền',
                  style: textDefaultLight,
                ),
                Text(
                  tempForm.currency ?? '',
                  style: textDefault,
                ),
                SizedBox(height: _spacing),
                const Text(
                  'Bảo vệ',
                  style: textDefaultLight,
                ),
                Text(
                  tempForm.bodyguard?.name?.decodeHtml ?? '',
                  style: textDefault,
                ),
                SizedBox(height: _spacing),
                const Text(
                  'Lái xe',
                  style: textDefaultLight,
                ),
                Text(
                  tempForm.driver?.name?.decodeHtml ?? '',
                  style: textDefault,
                ),
                SizedBox(height: _spacing),
                const Text(
                  'Xe',
                  style: textDefaultLight,
                ),
                Text(
                  tempForm.vehicle?.plateNumber?.decodeHtml ?? '',
                  style: textDefault,
                ),
                SizedBox(height: _spacing),
                Text(
                  'Thời gian tạo: ${tempForm.dateCreated?.toDate.toStringFormat()}',
                  style: textDefaultLight,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget get _sendMessage {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: TextInput(
              hint: 'Nhập lý do',
              labelText: 'Lý do',
              keyboardType: TextInputType.multiline,
              focusNode: _nodeTextInput,
              controller: _commentController,
            ),
          ),
        ],
      ),
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
                    confirmDialog(context, 'Bạn có chắc chắn duyệt PYC tạm?');
                dialog.then(
                  (value) {
                    if (value == true) {
                      _cubit.tempFormProcess(
                        TempFormProcessRequest(
                          id: widget.tempForm.id ?? '',
                          action: TempFormAction.APPROVED,
                          message: _commentController.text,
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ),
          const SizedBox(width: 20),
          Flexible(
            child: PrimaryButton(
              title: 'Từ chối',
              buttonHeight: 50,
              onPressed: () {
                final dialog =
                    confirmDialog(context, 'Bạn có chắc chắn từ chối PYC tạm?');
                dialog.then(
                  (value) {
                    if (value == true) {
                      _cubit.tempFormProcess(
                        TempFormProcessRequest(
                          id: widget.tempForm.id ?? '',
                          action: TempFormAction.REJECTED,
                          message: _commentController.text,
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
