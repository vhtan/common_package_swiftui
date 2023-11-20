import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvvm_cubit/common/widget/primary_button.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/data/model/temp_form/temp_form_response.dart';
import 'package:mvvm_cubit/view/pending_trip/widget/delete_request_form.dart';
import 'package:mvvm_cubit/view/pending_trip/widget/pending_trip_item_row_widget.dart';

class PendingTripScreen extends StatelessWidget {
  final TempFormResponse tempForm;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final ValueChanged<String> onClose;

  const PendingTripScreen({
    super.key,
    required this.tempForm,
    required this.onDelete,
    required this.onEdit,
    required this.onClose,
  });

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
              tempForm.code ?? '',
              style: textDefault,
            ),
          ],
        ),
        const SizedBox(height: 10),
        PendingTripItemRowWidget(
          icon: const Icon(Icons.map),
          title: 'Điểm đến:',
          description: tempForm.address?.address ?? '',
        ),
        const SizedBox(height: 10),
        PendingTripItemRowWidget(
          icon: const Icon(Icons.tag),
          title: 'Mục đích:',
          description: tempForm.purpose?.name?.decodeHtml ?? '',
        ),
        const SizedBox(height: 10),
        PendingTripItemRowWidget(
          icon: const Icon(Icons.drive_eta),
          title: tempForm.driver?.role?.name?.decodeHtml ?? '',
          description: tempForm.driver?.name?.decodeHtml ?? '',
        ),
        const SizedBox(height: 10),
        PendingTripItemRowWidget(
          icon: const Icon(Icons.security),
          title: tempForm.bodyguard?.role?.name?.decodeHtml ?? '',
          description: tempForm.bodyguard?.name?.decodeHtml ?? '',
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
                    tempForm.status?.displayName ?? '',
                    maxLines: 3,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: tempForm.status?.displayColor,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        const SizedBox(height: 10),
        if (tempForm.quantity != null)
          Row(
            children: [
              const Icon(Icons.attach_money_outlined),
              const SizedBox(width: 10),
              Text(
                'Số lượng: ${formatCurrency(tempForm.quantity ?? 0)}',
                style: textDefault,
              ),
              Text(
                tempForm.currency ?? 'VNĐ',
                style: textDefault,
              ),
            ],
          ),
        const SizedBox(height: 10),
        if (tempForm.status == TempFormStatus.NEW)
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  title: 'Sửa PYC',
                  buttonHeight: 50,
                  onPressed: () => onEdit(),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: PrimaryButton(
                  title: 'Huỷ PYC',
                  buttonHeight: 50,
                  onPressed: () async {
                    bool delete = await deleteRequestFormDialog(
                      'Huỷ phiếu yêu cầu',
                      'Bạn có chắc là muốn huỷ phiếu yêu cầu',
                      context,
                    );
                    if (delete) {
                      onDelete();
                    }
                  },
                ),
              ),
            ],
          ),
        if (tempForm.status != TempFormStatus.NEW)
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  title: 'Hoàn thành PYC tạm',
                  buttonHeight: 50,
                  onPressed: () async {
                    String? noted = await finishRequestFormDialog(
                      context,
                    );
                    if (noted != null) {
                      onClose(noted);
                    }
                  },
                ),
              )
            ],
          )
      ],
    );
  }

  String formatCurrency(double amount) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'vi_VN', symbol: '');
    return currencyFormatter.format(amount);
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
