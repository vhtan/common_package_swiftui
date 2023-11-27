import 'package:flutter/material.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/data/model/temp_form/temp_form_response.dart';
import 'package:mvvm_cubit/data/model/temp_form_history/temp_form_history_response.dart';

class TempFormHistoryItem extends StatelessWidget {
  final TempFormHistoryResponse tempFormHistoryResponse;

  const TempFormHistoryItem({
    super.key,
    required this.tempFormHistoryResponse,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
      decoration: BoxDecoration(
        color: tempFormHistoryResponse.status?.backgroudColor,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mã PYC tạm: ${tempFormHistoryResponse.code?.decodeHtml ?? ''}',
            style: headLine4,
            maxLines: 2,
            overflow: TextOverflow.clip,
          ),
          const SizedBox(height: 5),
          Text(
            'Mục đích di chuyển: ${tempFormHistoryResponse.purpose?.name?.decodeHtml ?? ''}',
            style: headLine4,
            maxLines: 3,
            overflow: TextOverflow.clip,
          ),
          const SizedBox(height: 5),
          Text(
            'Địa chỉ: ${tempFormHistoryResponse.address?.address?.decodeHtml ?? ''}',
            style: textDefault,
            maxLines: 4,
            overflow: TextOverflow.clip,
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Text(
                'Trạng thái:',
                style: textDefaultLight,
              ),
              const SizedBox(width: 10),
              Text(
                tempFormHistoryResponse.status?.displayName.decodeHtml ?? '',
                maxLines: 3,
                style: textDefault,
              )
            ],
          ),
          const SizedBox(height: 5),
          Text(
            'Thời gian tạo: ${tempFormHistoryResponse.dateCreated?.toDate.toStringFormat()}',
            style: headLine6,
            maxLines: 1,
            overflow: TextOverflow.clip,
          ),
        ],
      ),
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
      case TempFormStatus.REJECTED:
        return 'Từ chối';
    }
  }

  Color get backgroudColor {
    switch (this) {
      case TempFormStatus.NEW:
        return AppColors.newColor;
      case TempFormStatus.APPROVED:
        return AppColors.approved;
      case TempFormStatus.CLOSED:
        return AppColors.white;
      case TempFormStatus.CANCELED:
        return AppColors.cancel;
      case TempFormStatus.REJECTED:
        return AppColors.rejected;
    }
  }
}
