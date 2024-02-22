import 'dart:async';
import 'dart:io';
import 'package:camera_camera/camera_camera.dart';
import 'package:diffutil_dart/diffutil.dart' as diffutil;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:material_text_fields/utils/extensions.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/common/snack_bar/error_snack_bar.dart';
import 'package:mvvm_cubit/common/widget/image_capture.dart';
import 'package:mvvm_cubit/common/widget/text_input.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/data/model/chatting/chat_message_response.dart';
import 'package:mvvm_cubit/data/model/warning_details/warning_details_response.dart';
import 'package:mvvm_cubit/di.dart';
import 'package:mvvm_cubit/viewmodel/manager_role/manager_warnings_handler/manager_warnings_handler_state.dart';
import 'package:mvvm_cubit/viewmodel/sos_history_details/sos_history_details_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class SOSHistoryDetailsScreen extends StatefulWidget {
  final String id;
  final bool isCanChat;

  const SOSHistoryDetailsScreen({
    super.key,
    required this.id,
    required this.isCanChat,
  });

  @override
  State<StatefulWidget> createState() => _SOSHistoryDetailsScreen();
}

class _SOSHistoryDetailsScreen extends State<SOSHistoryDetailsScreen>
    with WidgetsBindingObserver {
  final _cubit = SOSHistoryDetailsCubit(repository: di());
  final double _spacing = 5;
  WarningDetailsResponse? _details;
  List<ChatMessageResponse> _messageList = [];
  final _commentController = TextEditingController();
  static Timer? _fetchMessages;
  final _timerDuration = const Duration(seconds: 10);
  final _scrollController = ScrollController();
  File? localFile;
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
    // _cubit.getWarningDetails(widget.id);
    // _cubit.getChattingList(widget.id);
    startFetchingMessages();
  }

  void startFetchingMessages() {
    cancelFetchingMessages();
    _fetchMessages = Timer.periodic(
      _timerDuration,
      (timer) {
        // _cubit.getChattingListForFetching(widget.id);
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
        "SOS",
        style: headLine1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
      child: BlocConsumer<SOSHistoryDetailsCubit, GenericCubitState>(
        listener: (context, state) {
          if (state.status == Status.failure) {
            showErrorSnackBar(
              context,
              'Đã có lỗi xảy ra vui lòng thử lại',
            );
          }
          if (state is DidSendWarningSuccess) {
            _commentController.text = '';
            // _cubit.getChattingList(widget.id);
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
              // _scrollController.animateTo(
              //   _scrollController.position.maxScrollExtent,
              //   duration: const Duration(milliseconds: 500),
              //   curve: Curves.easeInOut,
              // );
            });
          }
        },
        builder: (context, state) {
          return BlocBuilder<SOSHistoryDetailsCubit, GenericCubitState>(
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
                      controller: _scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(width: 20),
                              const Text(
                                'Thời gian tạo SOS',
                                style: textDefaultLight,
                              ),
                              const Spacer(),
                              Text(
                                DateTime.now().toStringFormat(),
                                style: headLine4,
                              ),
                              const SizedBox(width: 20),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(width: 20),
                              const Text(
                                'Nội dung SOS',
                                style: textDefaultLight,
                              ),
                              const Spacer(),
                            ],
                          ),
                          const Row(
                            children: [
                              SizedBox(width: 20),
                              Text(
                                'Va chạm cần hổ trợ',
                                style: headLine4,
                                maxLines: 3,
                                overflow: TextOverflow.clip,
                              ),
                              Spacer(),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                              top: 10,
                              bottom: 10,
                            ),
                            child: ImageCapture(
                              title: 'Chụp ảnh sự cố',
                              imageFile: localFile,
                              captureCallback: () => openCamera(context),
                              deleteCallback: () => {},
                            ),
                          ),
                          const Row(
                            children: [
                              SizedBox(width: 20),
                              Text(
                                'Ghi chú',
                                style: textDefaultLight,
                              ),
                              Spacer(),
                            ],
                          ),
                          const Row(
                            children: [
                              SizedBox(width: 20),
                              Text(
                                'va chạm tại ngã tư hàng xanh',
                                style: textDefaultLight,
                              ),
                              Spacer(),
                            ],
                          ),
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
              // onPressed: () {
              //   logger
              //       .d('message ${_scrollController.position.maxScrollExtent}');
              //   _scrollController.animateTo(
              //     1000,
              //     duration: const Duration(milliseconds: 100),
              //     curve: Curves.easeInOut,
              //   );
              // },
              onPressed: () => {},
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
    try {
      if (await canLaunchUrl(mapUrl)) {
        await launchUrl(mapUrl);
      } else {
        logger.e('Could not launch $mapUrl');
      }
    } catch (e) {
      logger.e(e);
    }
  }

  void openCamera(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Stack(
            children: [
              CameraCamera(
                resolutionPreset: ResolutionPreset.medium,
                onFile: (file) {
                  if (file.path.isNotNullOrEmpty()) {
                    setState(() {
                      localFile = file;
                    });
                  } else {}
                  Navigator.pop(context);
                },
              ),
              Positioned(
                top: 60,
                left: 16,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  backgroundColor: Colors.black45,
                  child: const Icon(Icons.close),
                ),
              ),
            ],
          ),
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
