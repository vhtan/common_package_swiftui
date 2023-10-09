import 'package:camera_camera/camera_camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/common/widget/image_capture.dart';
import 'package:mvvm_cubit/common/widget/primary_button.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/viewmodel/check_point/check_point_cubit.dart';

class CheckPointScreen extends StatefulWidget {
  const CheckPointScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CheckPointScreen();
}

class _CheckPointScreen extends State<CheckPointScreen> {
  CheckPointCubit authCubit = CheckPointCubit();

  @override
  Widget build(BuildContext context) {
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
            padding:
                const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
            child: BlocConsumer<CheckPointCubit, CheckPointData>(
              listener: (context, state) {},
              builder: (context, state) {
                return BlocBuilder<CheckPointCubit, CheckPointData>(
                  builder: (context, state) {
                    return Column(
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
                          imageFile: state.file,
                          captureCallback: () => openCamera(context),
                          deleteCallback: () => context
                              .read<CheckPointCubit>()
                              .didCapturePhoto(null),
                        ),
                        const SizedBox(height: 20),
                        PrimaryButton(
                          title: 'Gửi',
                          buttonHeight: 50,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void openCamera(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Stack(
            children: [
              CameraCamera(
                onFile: (file) {
                  context.read<CheckPointCubit>().didCapturePhoto(file);
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
                  backgroundColor: Theme.of(context).colorScheme.onPrimary,
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
