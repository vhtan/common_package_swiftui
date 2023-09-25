import 'package:flutter/material.dart';
import 'package:mvvm_cubit/common/widget/primary_button.dart';
import 'package:mvvm_cubit/common/widget/text_input.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_style.dart';

class WarningsHandlerScreen extends StatefulWidget {
  const WarningsHandlerScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WarningsHandlerScreen();
}

class _WarningsHandlerScreen extends State<WarningsHandlerScreen> {
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
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Hệ thống',
                      style: headLine6,
                    ),
                    Spacer(),
                    Text(
                      '03:45, 10/09/2023',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 12, // You can adjust the font size as needed.
                        // You can also set other properties like color, fontWeight, etc.
                      ),
                    ),
                  ],
                ),
                systemWarning(),
                const SizedBox(height: 20.0),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Nhân viên giám sát',
                      style: headLine6,
                    ),
                    Spacer(),
                    Text(
                      '03:45, 11/09/2023',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 12, // You can adjust the font size as needed.
                        // You can also set other properties like color, fontWeight, etc.
                      ),
                    ),
                  ],
                ),
                normalWarning(),
                const SizedBox(height: 20.0),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Nhân viên giám sát',
                      style: headLine6,
                    ),
                    Spacer(),
                    Text(
                      '03:45, 11/09/2023',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 12, // You can adjust the font size as needed.
                        // You can also set other properties like color, fontWeight, etc.
                      ),
                    ),
                  ],
                ),
                normal1Warning(),
                const SizedBox(height: 20),
                const TextInput(
                  hint: 'Nhập ý kiến',
                  labelText: 'Nhập ý kiến',
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
  }

  Widget systemWarning() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          // color: AppColors.warningHigh,
          // borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        child: const Row(
          children: [
            Icon(
              Icons.settings,
              color: AppColors.red,
              size: 24.0,
            ),
            SizedBox(width: 8.0), // Add spacing between elements
            Expanded(
              child: Text(
                'Hệ thống gửi cảnh báo cấp 1',
                style: textDefault,
                maxLines: 2,
                overflow: TextOverflow.ellipsis, // Specify an overflow property
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
      decoration: const BoxDecoration(
          // color: AppColors.warningHigh,
          // borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        child: const Row(
          children: [
            Icon(
              Icons.person,
              color: AppColors.red,
              size: 24.0,
            ),
            SizedBox(width: 8.0), // Add spacing between elements
            Expanded(
              child: Text(
                'Yêu cầu giải trình',
                style: textDefault,
                maxLines: 2,
                overflow: TextOverflow.ellipsis, // Specify an overflow property
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget normal1Warning() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          // color: AppColors.warningHigh,
          // borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        child: const Row(
          children: [
            Icon(
              Icons.person,
              color: AppColors.red,
              size: 24.0,
            ),
            SizedBox(width: 8.0), // Add spacing between elements
            Expanded(
              child: Text(
                'Xin ý kiến TĐV',
                style: textDefault,
                maxLines: 2,
                overflow: TextOverflow.ellipsis, // Specify an overflow property
              ),
            ),
          ],
        ),
      ),
    );
  }
}
