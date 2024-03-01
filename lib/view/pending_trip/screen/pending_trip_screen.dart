import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvvm_cubit/common/widget/primary_button.dart';
import 'package:mvvm_cubit/core/app_asset.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/data/model/temp_form/temp_form_response.dart';
import 'package:mvvm_cubit/view/pending_trip/widget/delete_request_form.dart';
import 'package:mvvm_cubit/view/pending_trip/widget/pending_trip_balance_details_widget.dart';
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
          description: tempForm.address?.address?.decodeHtml ?? '',
        ),
        const SizedBox(height: 10),
        PendingTripItemRowWidget(
          icon: const Icon(Icons.tag),
          title: 'Mục đích:',
          description: tempForm.purpose?.name?.decodeHtml ?? '',
        ),
        const SizedBox(height: 10),
        if ((tempForm.balanceDetails ?? []).isNotEmpty)
          PendingTripBalanceDetailsWidget(
            balanceDetails: tempForm.balanceDetails ?? [],
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
        if (tempForm.image != null) _imageWidget(tempForm.image!),
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
                  if ((tempForm.status == TempFormStatus.REJECTED ||
                          tempForm.status == TempFormStatus.APPROVED) &&
                      (tempForm.note ?? '').isNotEmpty)
                    Text(
                      '${tempForm.status == TempFormStatus.REJECTED ? 'Lý do từ chối' : 'Lý do được duyệt'}: ${tempForm.note?.decodeHtml ?? ''}',
                      maxLines: 3,
                      style: textDefault,
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // if (tempForm.quantity != null)
        //   Row(
        //     children: [
        //       const Icon(Icons.attach_money_outlined),
        //       const SizedBox(width: 10),
        //       Text(
        //         'Số lượng: ${formatCurrency(tempForm.quantity ?? 0)}',
        //         style: textDefault,
        //       ),
        //       Text(
        //         tempForm.currency?.decodeHtml ?? 'VNĐ',
        //         style: textDefault,
        //       ),
        //     ],
        //   ),
        const SizedBox(height: 10),
        if (tempForm.status == TempFormStatus.NEW ||
            tempForm.status == TempFormStatus.REJECTED)
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
        if (tempForm.status == TempFormStatus.APPROVED)
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

  Widget _imageWidget(String path) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        clipBehavior: Clip.antiAlias,
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: CachedNetworkImage(
            fit: BoxFit.fitWidth,
            imageUrl: path,
            placeholder: (context, url) => AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.asset(
                AppAsset.placeHolder,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ),
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
      case TempFormStatus.REJECTED:
        return 'Từ chối';
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
      case TempFormStatus.REJECTED:
        return AppColors.red;
    }
  }
}
