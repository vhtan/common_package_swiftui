import 'package:camera_camera/camera_camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_text_fields/utils/extensions.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/snack_bar/error_snack_bar.dart';
import 'package:mvvm_cubit/common/widget/image_capture.dart';
import 'package:mvvm_cubit/common/widget/primary_button.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_string.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/di.dart';
import 'package:mvvm_cubit/viewmodel/check_point/check_point_cubit.dart';

class CheckPointScreen extends StatefulWidget {
  final ValueChanged<CheckPointData> didCapture;

  const CheckPointScreen({
    super.key,
    required this.didCapture,
  });

  @override
  State<StatefulWidget> createState() => _CheckPointScreen();
}

class _CheckPointScreen extends State<CheckPointScreen> {
  CheckPointCubit cubit = CheckPointCubit(repository: di());

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
                    cubit.didCapturePhoto(file);
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: BlocConsumer<CheckPointCubit, GenericCubitState<CheckPointData>>(
        listener: (context, state) {
          if (state.status == Status.failure) {
            showErrorSnackBar(
              context,
              state.error ?? AppString.sendTimeOut,
            );
          }
        },
        builder: (context, state) {
          return BlocBuilder<CheckPointCubit,
              GenericCubitState<CheckPointData>>(
            builder: (context, state) {
              return Material(
                color: Colors.transparent,
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
                        left: 20,
                        right: 20,
                        bottom: 20,
                        top: 10,
                      ),
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
                                  'Xác nhận đến nơi',
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
                          ImageCapture(
                              title: 'Chụp ảnh xác nhận đến nơi',
                              imageFile: state.data?.file,
                              captureCallback: () => openCamera(context),
                              deleteCallback: () => {
                                    cubit.didCapturePhoto(null),
                                  }),
                          const SizedBox(height: 20),
                          PrimaryButton(
                            title: 'Gửi',
                            buttonHeight: 50,
                            backgroundColor: (state.data?.imagePath != null)
                                ? AppColors.primary
                                : AppColors.textDefaultLight,
                            onPressed: (state.data != null)
                                ? () {
                                    if (state.data != null) {
                                      widget.didCapture(state.data!);
                                    }
                                    Navigator.pop(context);
                                  }
                                : null,
                          )
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
}
