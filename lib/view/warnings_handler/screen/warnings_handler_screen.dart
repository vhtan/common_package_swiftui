import 'dart:async';
import 'package:diffutil_dart/diffutil.dart' as diffutil;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:material_text_fields/utils/extensions.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/common/widget/text_input.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/data/model/chatting/chat_message_response.dart';
import 'package:mvvm_cubit/data/model/warning_details/warning_details_response.dart';
import 'package:mvvm_cubit/data/request/warning_process/warning_process_request.dart';
import 'package:mvvm_cubit/di.dart';
import 'package:mvvm_cubit/viewmodel/manager_role/manager_warnings_handler/manager_warnings_handler_state.dart';
import 'package:mvvm_cubit/viewmodel/warnings_handler/warnings_handler_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class WarningsHandlerScreen extends StatefulWidget {
  final String id;
  final bool isCanChat;

  const WarningsHandlerScreen({
    super.key,
    required this.id,
    required this.isCanChat,
  });

  @override
  State<StatefulWidget> createState() => _WarningsHandlerScreen();
}

class _WarningsHandlerScreen extends State<WarningsHandlerScreen>
    with WidgetsBindingObserver {
  final _cubit = WarningsHandlerCubit(repository: di());
  final double _spacing = 5;
  WarningDetailsResponse? _details;
  List<ChatMessageResponse> _messageList = [];
  final _commentController = TextEditingController();
  static Timer? _fetchMessages;
  final _timerDuration = const Duration(seconds: 10);

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
      create: (context) => _cubit,
      child: BlocConsumer<WarningsHandlerCubit, GenericCubitState>(
        listener: (context, state) {
          if (state is DidSendWarningSuccess) {
            _commentController.text = '';
            _cubit.getChattingList(widget.id);
          }
          if (state is GetWarningDetailsSuccess) {
            setState(() {
              _details = state.warningDetails;
            });
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
          return BlocBuilder<WarningsHandlerCubit, GenericCubitState>(
            builder: (context, state) {
              return SafeArea(
                child: Scaffold(
                  resizeToAvoidBottomInset: true,
                  appBar: _appBar,
                  bottomNavigationBar: widget.isCanChat
                      ? Padding(
                          padding: MediaQuery.of(context).viewInsets,
                          child: _sendMessage,
                        )
                      : null,
                  backgroundColor: AppColors.white,
                  body: KeyboardActions(
                    tapOutsideBehavior: TapOutsideBehavior.opaqueDismiss,
                    config: _keyboardActionsConfig(context),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                              top: 20,
                              bottom: 10,
                            ),
                            child: Text(
                              _details?.warningMessage?.decodeHtml ?? '',
                              style: headLine2,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Row(
                            children: [
                              const SizedBox(width: 20),
                              const Text(
                                'Địa điểm bắt đầu cảnh báo',
                                style: textDefaultLight,
                              ),
                              const Spacer(),
                              TextButton(
                                style: ButtonStyle(
                                  side: MaterialStateProperty.all(
                                      BorderSide.none),
                                ),
                                onPressed: () => openMap(
                                  longitude: _details?.startLongitude ?? 0,
                                  latitude: _details?.startLatitude ?? 0,
                                ),
                                child: const Icon(
                                  Icons.map,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Text(
                              _details?.startAddress?.decodeHtml ?? '',
                              maxLines: 3,
                              style: textDefault,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(width: 20),
                              const Text(
                                'Thời gian bắt đầu cảnh báo',
                                style: textDefaultLight,
                              ),
                              const Spacer(),
                              Text(
                                (_details?.startTime ?? 0)
                                    .toDate
                                    .toStringFormat(),
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 20),
                            ],
                          ),
                          const SizedBox(height: 20),
                          if (_details?.endAddress.isNotNullOrEmpty() == true)
                            Row(
                              children: [
                                const SizedBox(width: 20),
                                const Text(
                                  'Địa điểm kết thúc cảnh báo',
                                  style: textDefaultLight,
                                ),
                                const Spacer(),
                                TextButton(
                                  style: ButtonStyle(
                                    side: MaterialStateProperty.all(
                                        BorderSide.none),
                                  ),
                                  onPressed: () => openMap(
                                    longitude: _details?.endLongitude ?? 0,
                                    latitude: _details?.endLatitude ?? 0,
                                  ),
                                  child: const Icon(Icons.map),
                                ),
                              ],
                            ),
                          if (_details?.endAddress.isNotNullOrEmpty() == true)
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Text(
                                _details?.endAddress?.decodeHtml ?? '',
                                maxLines: 3,
                                style: textDefault,
                              ),
                            ),
                          if ((_details?.endTime ?? 0) > 0)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(width: 20),
                                const Text(
                                  'Thời gian kết thúc cảnh báo',
                                  style: textDefaultLight,
                                ),
                                const Spacer(),
                                Text(
                                  (_details?.endTime ?? 0)
                                      .toDate
                                      .toStringFormat(),
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 20),
                              ],
                            ),
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

  Widget get _sendMessage {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
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
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              onPressed: () => _cubit.warningProcess(
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

  void openMap({
    required double latitude,
    required double longitude,
  }) async {
    Uri mapUrl = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude&hl=vi');
    logger.d('openMap openMap $mapUrl');
    if (await canLaunchUrl(mapUrl)) {
      await launchUrl(mapUrl);
    } else {
      logger.e('Could not launch $mapUrl');
    }
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
