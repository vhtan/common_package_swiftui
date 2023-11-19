import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/widget/text_input.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/data/model/chatting/chat_message_response.dart';
import 'package:mvvm_cubit/data/model/warning_details/warning_details_response.dart';
import 'package:mvvm_cubit/data/request/warning_process/warning_process_request.dart';
import 'package:mvvm_cubit/di.dart';
import 'package:mvvm_cubit/viewmodel/manager_role/manager_warnings_handler/manager_warnings_handler_state.dart';
import 'package:mvvm_cubit/viewmodel/warnings_handler/warnings_handler_cubit.dart';

class WarningsHandlerScreen extends StatefulWidget {
  final String id;

  const WarningsHandlerScreen({
    super.key,
    required this.id,
  });

  @override
  State<StatefulWidget> createState() => _WarningsHandlerScreen();
}

class _WarningsHandlerScreen extends State<WarningsHandlerScreen> {
  final cubit = WarningsHandlerCubit(repository: di());

  WarningDetailsResponse? _details;
  List<ChatMessageResponse> _messageList = [];
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

  @override
  void initState() {
    super.initState();
    cubit.getWarningDetails(widget.id);
    cubit.getChattingList(widget.id);
  }

  PreferredSizeWidget get _appBar {
    return AppBar(
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
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: BlocConsumer<WarningsHandlerCubit, GenericCubitState>(
        listener: (context, state) {
          if (state is ProcessWarningSuccess) {
            _commentController.text = '';
            cubit.getChattingList(widget.id);
          }
          if (state is GetWarningDetailsSuccess) {
            setState(() {
              _details = state.warningDetails;
            });
          } else if (state is ChattingListWarningSuccess) {
            setState(() {
              _messageList = state.list;
            });
          }
        },
        builder: (context, state) {
          return BlocBuilder<WarningsHandlerCubit, GenericCubitState>(
            builder: (context, state) {
              return SafeArea(
                child: Scaffold(
                  resizeToAvoidBottomInset: true,
                  appBar: _appBar,
                  bottomNavigationBar: Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: _sendMessage,
                  ),
                  backgroundColor: AppColors.white,
                  body: KeyboardActions(
                    tapOutsideBehavior: TapOutsideBehavior.opaqueDismiss,
                    config: _keyboardActionsConfig(context),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20.0),
                          _warningMessage(_details),
                          const SizedBox(height: 10.0),
                          _systemMessage(_details),
                          systemWarning(_details?.level),
                          const Divider(),
                          ..._messageList.map(
                            (item) {
                              return _MessageWidget(
                                userName:
                                    item.userCreated?.name?.decodeHtml ?? '',
                                message: item.text?.decodeHtml ?? '',
                                dateCreated: item.dateCreated ?? 0,
                                roleCode: item.userCreated?.role?.code,
                              );
                            },
                          ),
                          const SizedBox(height: 20.0),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
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
            maxLines: 3,
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
          (details?.dateCreated ?? 0).toDate.toStringFormat(),
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
    return Row(
      children: [
        const SizedBox(width: 20),
        Expanded(
          child: TextInput(
            focusNode: _nodeTextInput,
            hint: 'Nhập ý kiến',
            labelText: 'Nhập ý kiến',
            controller: _commentController,
          ),
        ),
        const SizedBox(width: 20),
        SizedBox(
          height: 50,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(AppColors.primary),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            onPressed: () => cubit.warningProcess(
              WarningProcessRequest(
                warningId: widget.id,
                action: 'explain',
                message: _commentController.text,
              ),
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
        const SizedBox(width: 20),
      ],
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
                'Hệ thống gửi cảnh báo cấp ${level ?? 1}',
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
      decoration: const BoxDecoration(),
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
        top: 10,
        bottom: 10,
      ),
      color:
          roleCode == 'ATAI' ? AppColors.white : AppColors.notificationUnread,
      child: Column(
        children: [
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
                  // maxLines: 0,
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
