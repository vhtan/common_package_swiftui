import 'package:camera_camera/camera_camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_text_fields/utils/extensions.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/widget/drop_down.dart';
import 'package:mvvm_cubit/common/widget/image_capture.dart';
import 'package:mvvm_cubit/common/widget/primary_button.dart';
import 'package:mvvm_cubit/common/widget/text_input.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/di.dart';
import 'package:mvvm_cubit/viewmodel/report_sos/report_sos_cubit.dart';

class ReportSOSScreen extends StatefulWidget {
  const ReportSOSScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ReportSOSScreen();
}

class _ReportSOSScreen extends State<ReportSOSScreen> {
  final cubit = ReportSOSCubit(repository: di());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: BlocConsumer<ReportSOSCubit, GenericCubitState>(
        listener: (context, state) {},
        builder: (context, state) {
          return BlocBuilder<ReportSOSCubit, GenericCubitState<ReportSOSData>>(
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
                          DropDown<String>(
                            items: const [
                              'Xe hư',
                              'Hết xăng',
                              'Thủng lốp',
                              'Sự cố khác'
                            ],
                            displayTextBuilder: (value) => value,
                            onChanged: (value) {},
                          ),
                          const SizedBox(height: 20),
                          // if (state.file != null)
                          //   AspectRatio(
                          //     aspectRatio: 16 / 9,
                          //     child: Container(
                          //       clipBehavior: Clip.antiAlias,
                          //       decoration: const BoxDecoration(
                          //         borderRadius:
                          //             BorderRadius.all(Radius.circular(8)),
                          //       ),
                          //       child: Image.file(
                          //         state.file!,
                          //         fit: BoxFit.fitWidth,
                          //       ),
                          //     ),
                          //   ),
                          // if (state.file != null) const SizedBox(height: 20),
                          ImageCapture(
                            title: 'Chụp ảnh sự cố',
                            imageFile: state.data?.file,
                            captureCallback: () => openCamera(context),
                            deleteCallback: () =>
                                cubit.didCapturePhoto(null, ''),
                          ),
                          const SizedBox(height: 20),
                          const TextInput(
                            hint: 'Nhập mô tả sự cố',
                            labelText: 'Mô tả sự cố',
                            maxLines: 6, // and this
                            keyboardType: TextInputType.multiline,
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

  void openCamera(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Stack(
            children: [
              CameraCamera(
                onFile: (file) {
                  if (file.path.isNotNullOrEmpty()) {
                    // upload photo here
                    cubit.didCapturePhoto(file, '');
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
