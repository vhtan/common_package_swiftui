import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera_camera/camera_camera.dart';
import 'package:diffutil_dart/diffutil.dart' as diffutil;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:material_text_fields/utils/extensions.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/common/snack_bar/error_snack_bar.dart';
import 'package:mvvm_cubit/common/widget/text_input.dart';
import 'package:mvvm_cubit/core/app_asset.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/data/model/chatting/chat_message_response.dart';
import 'package:mvvm_cubit/data/model/sos_history_details/sos_history_details_response.dart';
import 'package:mvvm_cubit/data/request/sos_process_request/sos_process_request.dart';
import 'package:mvvm_cubit/di.dart';
import 'package:mvvm_cubit/viewmodel/sos_history_details/sos_history_details_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class SOSHistoryDetailsScreen extends StatefulWidget {
  final String id;

  const SOSHistoryDetailsScreen({
    super.key,
    required this.id,
  });

  @override
  State<StatefulWidget> createState() => _SOSHistoryDetailsScreen();
}

class _SOSHistoryDetailsScreen extends State<SOSHistoryDetailsScreen>
    with WidgetsBindingObserver {
  final _cubit = SOSHistoryDetailsCubit(repository: di());
  final double _spacing = 5;
  SOSHistoryDetailsResponse? _details;
  List<ChatMessageResponse> _messageList = [];
  final _commentController = TextEditingController();
  static Timer? _fetchMessages;
  final _timerDuration = const Duration(seconds: 10);
  final _scrollController = ScrollController();
  File? localFile;
  bool _isCanChat = false;
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
    _cubit.getSOSHistoryDetails(widget.id);
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
          if (state is DidSendSOSMessageSuccess) {
            _commentController.text = '';
            _cubit.getChattingList(widget.id);
          }
          if (state is GetSOSHistoryDetailsState) {
            setState(() {
              _details = state.sosDetails;
              _isCanChat = (_details?.status ?? 0) < 5;
            });
          } else if (state is ChattingListSOSSuccess) {
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
                  bottomNavigationBar: _isCanChat
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
                                (_details?.dateCreated ?? 0)
                                    .toDate
                                    .toStringFormat(),
                                style: headLine4,
                              ),
                              const SizedBox(width: 20),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 20),
                              Text(
                                'Nội dung SOS',
                                style: textDefaultLight,
                              ),
                              Spacer(),
                            ],
                          ),
                          Row(
                            children: [
                              const SizedBox(width: 20),
                              Text(
                                _sosContent,
                                style: headLine4,
                                maxLines: 3,
                                overflow: TextOverflow.clip,
                              ),
                              const Spacer(),
                            ],
                          ),
                          if (_details?.image?.isNotNullOrEmpty() == true)
                            const SizedBox(height: 10),
                          if (_details?.image?.isNotNullOrEmpty() == true)
                            _imageWidget(_details?.image ?? ''),
                          const SizedBox(height: 10),
                          if (_details?.note.isNotNullOrEmpty() == true)
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
                          if (_details?.note.isNotNullOrEmpty() == true)
                            Row(
                              children: [
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Text(
                                    _details?.note?.decodeHtml ?? '',
                                    style: headLine4,
                                  ),
                                ),
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

  String get _sosContent {
    switch (_details?.type) {
      case 2:
        return 'Bị cướp';
      case 1:
        return 'Bị bắt giữ';
      default:
        return _details?.reason?.name ?? '';
    }
  }

  Widget _imageWidget(String path) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        clipBehavior: Clip.antiAlias,
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: CachedNetworkImage(
            fit: BoxFit.fitWidth,
            imageUrl: path,
            placeholder: (context, url) => AspectRatio(
              aspectRatio: 1,
              child: Image.asset(
                AppAsset.placeHolder,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget get _sendMessage {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: TextInputCustom(
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
              onPressed: () => _cubit.sendMessage(
                SOSProcessRequest(
                  sosId: widget.id,
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
