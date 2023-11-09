import 'dart:io';

import 'package:camera_camera/camera_camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:material_text_fields/utils/extensions.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/dialog/progress_dialog.dart';
import 'package:mvvm_cubit/common/widget/drop_down.dart';
import 'package:mvvm_cubit/common/widget/image_capture.dart';
import 'package:mvvm_cubit/common/widget/primary_button.dart';
import 'package:mvvm_cubit/common/widget/text_input.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/data/api/sos/sos_submit_request.dart';
import 'package:mvvm_cubit/data/model/sos/child_sos_response.dart';
import 'package:mvvm_cubit/di.dart';
import 'package:mvvm_cubit/viewmodel/report_sos/report_sos_cubit.dart';
import 'package:mvvm_cubit/viewmodel/report_sos/report_state.dart';

class ReportSOSScreen extends StatefulWidget {
  const ReportSOSScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ReportSOSScreen();
}

class _ReportSOSScreen extends State<ReportSOSScreen> {
  final cubit = ReportSOSCubit(repository: di());
  List<ChildSOSResponse> reasons = [];
  ChildSOSResponse? selectedReason;
  String? uploadedUrl;
  String? describeReason;
  File? localFile;

  final GlobalKey<State> progressKey = GlobalKey<State>();

  @override
  void initState() {
    super.initState();
    cubit.getReasons();
  }

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
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: BlocConsumer<ReportSOSCubit, GenericCubitState>(
        listener: (context, state) {
          final data = state.data;
          if (state.status == Status.loading) {
            // showProgressDialog(
            //   context,
            //   progressKey,
            // );
          }
          if (data is DidSubmitReasonSuccess) {
            Navigator.of(context).pop();
          }
          if (data is UploadImageSuccess) {
            setState(
              () {
                uploadedUrl = data.uploadUrl;
                localFile = data.file;
              },
            );
          } else if (data is GetReasonsSuccess) {
            setState(
              () {
                reasons.clear();
                reasons.addAll(data.reasons);
                selectedReason = reasons.first;
              },
            );
          }
        },
        builder: (context, state) {
          return BlocBuilder<ReportSOSCubit, GenericCubitState>(
            builder: (context, state) {
              return Scaffold(
                backgroundColor: Colors.transparent,
                resizeToAvoidBottomInset: true,
                body: KeyboardActions(
                  isDialog: true,
                  config: _keyboardActionsConfig(context),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        alignment: Alignment.center,
                        child: IntrinsicHeight(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 20, top: 10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Stack(
                                  alignment: AlignmentDirectional.center,
                                  children: [
                                    const Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Báo cáo sự cố',
                                        style: headLine1,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: IconButton(
                                        color: Colors.black,
                                        icon: const Icon(Icons.close),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                (reasons.isNotEmpty)
                                    ? DropDown<ChildSOSResponse>(
                                        items: reasons,
                                        displayTextBuilder: (value) =>
                                            value.name ?? '',
                                        onChanged: (value) {
                                          setState(() {
                                            selectedReason = value;
                                          });
                                        },
                                      )
                                    : const SizedBox(),
                                const SizedBox(height: 20),
                                ImageCapture(
                                  title: 'Chụp ảnh sự cố',
                                  imageFile: localFile,
                                  captureCallback: () => openCamera(context),
                                  deleteCallback: () => {
                                    setState(() {
                                      localFile = null;
                                      uploadedUrl = null;
                                    })
                                  },
                                ),
                                const SizedBox(height: 20),
                                TextInput(
                                  focusNode: _nodeTextInput,
                                  hint: 'Nhập mô tả sự cố',
                                  labelText: 'Mô tả sự cố',
                                  maxLines: 4, // and this
                                  keyboardType: TextInputType.multiline,
                                  onChanged: (value) => {
                                    setState(
                                      () {
                                        describeReason = value;
                                      },
                                    )
                                  },
                                ),
                                const SizedBox(height: 20),
                                PrimaryButton(
                                  title: 'Gửi',
                                  buttonHeight: 50,
                                  backgroundColor: validSubmitSOS() == true
                                      ? AppColors.primary
                                      : AppColors.textDefaultLight,
                                  onPressed: validSubmitSOS() == true
                                      ? () {
                                          cubit.submitSOS(
                                            SOSSubmitRequest(
                                              reasonId: selectedReason?.id,
                                              imgUrl: uploadedUrl,
                                              sosMessage: describeReason,
                                              requestId:
                                                  selectedReason?.requestId,
                                              requestTime:
                                                  selectedReason?.requestTime,
                                            ),
                                          );
                                        }
                                      : null,
                                )
                              ],
                            ),
                          ),
                        ),
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

  bool validSubmitSOS() {
    if (selectedReason != null &&
        uploadedUrl.isNotNullOrEmpty() &&
        describeReason.isNotNullOrEmpty()) {
      return true;
    }
    return false;
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
                    // upload photo here
                    cubit.didCapturePhoto(file);
                  } else {
                    // display error
                  }
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
