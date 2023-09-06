import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mvvm_cubit/common/widget/drop_down.dart';
import 'package:mvvm_cubit/common/widget/primary_button.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/view/report_sos/widget/image_sos.dart';

class ReportSOSScreen extends StatefulWidget {
  const ReportSOSScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ReportSOSScreen();
}

class _ReportSOSScreen extends State<ReportSOSScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
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
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 20),
                  const ImageSOS(),
                  const SizedBox(height: 20),
                  const TextField(
                    decoration: InputDecoration(
                        hintText: 'Mô tả sự cố',
                        contentPadding: EdgeInsets.all(10)),
                    minLines: 3, // Set this
                    maxLines: 6, // and this
                    keyboardType: TextInputType.multiline,
                    style: textDefault,
                  ),
                  const SizedBox(height: 20),
                  PrimaryButton(
                    title: 'Gửi',
                    buttonHeight: 50,
                    onPressed: () {
                      // Navigator.pop(context);
                      openCamera();
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> openCamera() async {
    WidgetsFlutterBinding.ensureInitialized();

    _cameras = await availableCameras();
    runApp(const CameraApp());
  }
}

class CameraApp extends StatefulWidget {
  /// Default Constructor
  const CameraApp({super.key});

  @override
  State<CameraApp> createState() => _CameraAppState();
}

late List<CameraDescription> _cameras;

class _CameraAppState extends State<CameraApp> {
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(_cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return MaterialApp(
      home: CameraPreview(controller),
    );
  }
}
