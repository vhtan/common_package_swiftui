import 'package:flutter/material.dart';
import 'package:mvvm_cubit/common/widget/primary_button.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/view/report_sos/widget/drop_down_list.dart';
import 'package:mvvm_cubit/view/report_sos/widget/image_sos.dart';

class ReportSOSScreen extends StatefulWidget {
  const ReportSOSScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ReportSOSScreen();
}

class _ReportSOSScreen extends State<ReportSOSScreen> {
  final List<String> items = [
    "Item 1",
    "Item 2",
    "Item 3",
    "Item 4",
    "Item 5",
  ];

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
                  const DropdownList(),
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
                    onPressed: () {},
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
