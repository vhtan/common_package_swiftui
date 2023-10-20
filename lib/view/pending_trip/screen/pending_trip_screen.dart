import 'package:flutter/material.dart';
import 'package:mvvm_cubit/common/widget/primary_button.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/data/model/temp_form/temp_form_response.dart';
import 'package:mvvm_cubit/view/pending_trip/widget/delete_request_form.dart';
import 'package:mvvm_cubit/view/pending_trip/widget/pending_trip_item_row_widget.dart';

class PendingTripScreen extends StatefulWidget {
  final TempFormResponse tempForm;
  final VoidCallback onDelete;
  final ValueChanged<String> onEdit;

  const PendingTripScreen({
    super.key,
    required this.tempForm,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  State<StatefulWidget> createState() => _PendingTripScreen();
}

class _PendingTripScreen extends State<PendingTripScreen> {
  late TempFormResponse _tempForm;

  @override
  void initState() {
    super.initState();

    _tempForm = widget.tempForm;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              'Phiếu yêu cầu tạm:',
              style: textDefault,
            ),
            const SizedBox(width: 10),
            Text(
              _tempForm.routeId ?? '',
              style: textDefault,
            ),
          ],
        ),
        const SizedBox(height: 10),
        PendingTripItemRowWidget(
          icon: const Icon(Icons.map),
          title: 'Điểm đến:',
          description: _tempForm.address?.address ?? '',
        ),
        const SizedBox(height: 10),
        PendingTripItemRowWidget(
          icon: const Icon(Icons.tag),
          title: 'Mục đích:',
          description: _tempForm.purpose?.name ?? '',
        ),
        const SizedBox(height: 10),
        PendingTripItemRowWidget(
          icon: const Icon(Icons.drive_eta),
          title: _tempForm.driver?.role?.name ?? '',
          description: _tempForm.driver?.name ?? '',
        ),
        const SizedBox(height: 10),
        PendingTripItemRowWidget(
          icon: const Icon(Icons.security),
          title: _tempForm.bodyguard?.role?.name ?? '',
          description: _tempForm.bodyguard?.name ?? '',
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.security),
            const SizedBox(width: 10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Trạng thái:',
                    style: textDefaultLight,
                  ),
                  Text(
                    _tempForm.status?.displayName ?? '',
                    maxLines: 3,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: _tempForm.status?.displayColor,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        // const SizedBox(height: 10),
        // const Row(
        //   children: [
        //     Text(
        //       'Dự kiến hoàn thành:',
        //       style: textDefault,
        //     ),
        //     SizedBox(width: 10),
        //     Text(
        //       '15:20, 10/09/2023',
        //       style: textDefault,
        //     ),
        //   ],
        // ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: PrimaryButton(
                title: 'Sửa PYC',
                buttonHeight: 50,
                onPressed: () => widget.onEdit(_tempForm.routeId ?? ''),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: PrimaryButton(
                title: 'Huỷ PYC',
                buttonHeight: 50,
                onPressed: () async {
                  bool delete = await deleteRequestFormDialog(
                    'Xoá phiếu yêu cầu',
                    'Bạn có chắc là muốn xoá phiếu yêu cầu',
                    context,
                  );
                  if (delete) {
                    widget.onDelete();
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

extension _TempFormStatusDisplay on TempFormStatus {
  String get displayName {
    switch (this) {
      case TempFormStatus.NEW:
        return 'Mới tạo';
      case TempFormStatus.APPROVED:
        return 'Đã duyệt';
      case TempFormStatus.CLOSED:
        return 'Đã đóng';
      case TempFormStatus.CANCELED:
        return 'Đã huỷ';
    }
  }

  Color get displayColor {
    switch (this) {
      case TempFormStatus.NEW:
        return AppColors.primary;
      case TempFormStatus.APPROVED:
        return AppColors.warning;
      case TempFormStatus.CLOSED:
        return AppColors.warningHigh;
      case TempFormStatus.CANCELED:
        return AppColors.red;
    }
  }
}
