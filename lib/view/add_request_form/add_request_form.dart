import 'package:flutter/material.dart';
import 'package:mvvm_cubit/common/widget/drop_down.dart';
import 'package:mvvm_cubit/common/widget/primary_button.dart';
import 'package:mvvm_cubit/common/widget/text_input.dart';
import 'package:mvvm_cubit/core/app_style.dart';

class AddRequestFormScreen extends StatefulWidget {
  const AddRequestFormScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddRequestFormScreen();
}

class _AddRequestFormScreen extends State<AddRequestFormScreen> {
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
                        'Thêm phiếu yêu cầu',
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
                    'Mục đích',
                    'Đổ xăng',
                    'Sửa xe',
                    'Mục đích khác'
                  ],
                  onChanged: (value) {},
                ),
                const SizedBox(height: 20),
                const TextInput(
                  hint: 'Nhập điểm dừng',
                  labelText: 'Điểm dừng',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                const TextInput(
                  hint: 'Nhập số tiền',
                  labelText: 'Số tiền',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                DropDown<String>(
                  items: const ['Loại xe', 'For', 'Toyota', 'Chevrolet'],
                  onChanged: (value) {},
                ),
                const SizedBox(height: 20),
                DropDown<String>(
                  items: const ['Bảo vệ', 'For', 'Toyota', 'Chevrolet'],
                  onChanged: (value) {},
                ),
                const SizedBox(height: 20),
                const TextInput(
                  hint: 'Nhập biển số xe',
                  labelText: 'Biển số xe',
                  keyboardType: TextInputType.number,
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
}
