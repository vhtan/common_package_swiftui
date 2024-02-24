import 'dart:async';
import 'package:diffutil_dart/diffutil.dart' as diffutil;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/dialog/delete_dialog.dart';
import 'package:mvvm_cubit/common/widget/primary_button.dart';
import 'package:mvvm_cubit/common/widget/text_input.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/data/model/chatting/chat_message_response.dart';
import 'package:mvvm_cubit/data/model/warning_details/warning_details_response.dart';
import 'package:mvvm_cubit/data/request/warning_process/warning_process_request.dart';
import 'package:mvvm_cubit/di.dart';
import 'package:mvvm_cubit/viewmodel/manager_role/manager_warnings_handler/manager_warnings_handler_cubit.dart';
import 'package:mvvm_cubit/viewmodel/manager_role/manager_warnings_handler/manager_warnings_handler_state.dart';

class ManagerWarningsHandlerScreen extends StatefulWidget {
  final String id;

  const ManagerWarningsHandlerScreen({super.key, required this.id});

  @override
  State<StatefulWidget> createState() => _ManagerWarningsHandlerScreen();
}

class _ManagerWarningsHandlerScreen extends State<ManagerWarningsHandlerScreen>
    with WidgetsBindingObserver {
  final _cubit = ManagerWarningsHandlerCubit(repository: di());
  final double _spacing = 5;
  WarningDetailsResponse? _details;
  List<ChatMessageResponse> _messageList = [];
  static Timer? _fetchMessages;
  final _timerDuration = const Duration(seconds: 10);

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
        "Cảnh báo",
        style: headLine1,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _cubit.getWarningDetails(widget.id);
    _cubit.getChattingList(widget.id);
    startFetchingMessages();
  }

  void startFetchingMessages() {
    cancelFetchingMessages();
    _fetchMessages = Timer.periodic(
      _timerDuration,
      (timer) {
        _cubit.getChattingListForFetching(widget.id);
      },
    );
  }

  static void cancelFetchingMessages() {
    _fetchMessages?.cancel();
    _fetchMessages = null;
  }

  @override
  void dispose() {
    cancelFetchingMessages();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
      child: BlocConsumer<ManagerWarningsHandlerCubit, GenericCubitState>(
        listener: (context, state) {
          if (state is DidSendWarningSuccess) {
            _commentController.text = '';
            _cubit.getChattingList(widget.id);
          }
          if (state is GetWarningDetailsSuccess) {
            setState(() {
              _details = state.warningDetails;
            });
          } else if (state is DidProcessWarningSuccess) {
            Navigator.pop(context, true);
          } else if (state is ChattingListWarningSuccess) {
            var listDiff = diffutil
                .calculateListDiff(
                  _messageList,
                  state.list,
                )
                .getUpdates();

            if (state.list.isNotEmpty &&
                _messageList.isNotEmpty &&
                listDiff.isEmpty) {
              return;
            }
            setState(() {
              _messageList = state.list;
            });
          }
        },
        builder: (context, state) {
          return BlocBuilder<ManagerWarningsHandlerCubit, GenericCubitState>(
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
    return Column(
      children: [
        const SizedBox(height: 20.0),
        _warningMessage(_details),
        const SizedBox(height: 20.0),
        SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Row(
                children: [
                  SizedBox(width: 20),
                  Text(
                    'Địa điểm bắt đầu cảnh báo',
                    style: textDefaultLight,
                  ),
                ],
              ),
              SizedBox(height: _spacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 20),
                  Text(
                    _details?.startAddress?.decodeHtml ?? '',
                    maxLines: 3,
                    style: textDefault,
                  ),
                  const SizedBox(width: 20),
                ],
              ),
              SizedBox(height: _spacing),
              _systemMessage(_details),
              systemWarning(_details?.level),
              const Divider(),
              ..._messageList.map(
                (item) {
                  return Container(
                    padding: const EdgeInsets.only(
                      top: 10,
                    ),
                    child: _MessageWidget(
                      userName: item.userCreated?.name?.decodeHtml ?? '',
                      message: item.text?.decodeHtml ?? '',
                      dateCreated: item.dateCreated ?? 0,
                      roleCode: item.userCreated?.role?.code,
                    ),
                  );
                },
              ),
              _sendMessage,
            ],
          ),
        )
      ],
    );
  }

  Widget _warningMessage(WarningDetailsResponse? details) {
    return Row(
      children: [
        const SizedBox(width: 20),
        Flexible(
          child: Text(
            details?.warningMessage?.decodeHtml ?? '',
            style: headLine4,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _systemMessage(WarningDetailsResponse? details) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(width: 20),
        const Text(
          'Hệ thống',
          style: headLine6,
        ),
        const Spacer(),
        Text(
          (details?.startTime ?? 0).toDate.toStringFormat(),
          style: const TextStyle(
            fontStyle: FontStyle.italic,
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 20),
      ],
    );
  }

  Widget get _sendMessage {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: TextInputCustom(
              hint: 'Nhập ý kiến',
              labelText: 'Nhập ý kiến',
              keyboardType: TextInputType.multiline,
              focusNode: _nodeTextInput,
              controller: _commentController,
            ),
          ),
          const SizedBox(width: 20),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  AppColors.primary,
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              onPressed: () => _cubit.sendMessage(
                WarningProcessRequest(
                    warningId: widget.id,
                    action: 'explain',
                    message: _commentController.text),
              ),
              child: const Text(
                'Gửi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
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
                    confirmDialog(context, 'Bạn có chắc chắn đồng ý cảnh báo?');
                dialog.then((value) {
                  if (value == true) {
                    _cubit.warningProcess(
                      WarningProcessRequest(
                          warningId: widget.id,
                          action: 'accept',
                          message: _commentController.text),
                    );
                  }
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
                  if (value == true) {
                    _cubit.warningProcess(
                      WarningProcessRequest(
                          warningId: widget.id,
                          action: 'reject',
                          message: _commentController.text),
                    );
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget systemWarning(int? level) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
      decoration: const BoxDecoration(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        child: Row(
          children: [
            const Icon(
              Icons.settings,
              color: AppColors.red,
              size: 24.0,
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Text(
                'Hệ thống gửi cảnh báo cấp $level',
                style: textDefault,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget normalWarning() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          // color: AppColors.warningHigh,
          // borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        child: const Row(
          children: [
            Icon(
              Icons.request_quote,
              color: AppColors.red,
              size: 24.0,
            ),
            SizedBox(width: 8.0),
            Expanded(
              child: Text(
                'Yêu cầu giải trình',
                style: textDefault,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageWidget extends StatelessWidget {
  final String userName;
  final String message;
  final int dateCreated;
  final String? roleCode;

  const _MessageWidget({
    required this.userName,
    required this.message,
    required this.dateCreated,
    required this.roleCode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 10,
      ),
      color:
          roleCode == 'ATAI' ? AppColors.white : AppColors.notificationUnread,
      child: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                userName,
                style: headLine6,
              ),
              const Spacer(),
              Text(
                dateCreated.toDate.toStringFormat(),
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.person_2,
                color: AppColors.red,
                size: 24.0,
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  message,
                  style: textDefault,
                  maxLines: 10,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
