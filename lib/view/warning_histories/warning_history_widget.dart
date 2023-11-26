import 'package:flutter/material.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/data/model/warning_details/warning_details_response.dart';

class WarningHistoryWidget extends StatelessWidget {
  final WarningDetailsResponse warning;

  const WarningHistoryWidget({
    super.key,
    required this.warning,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
      decoration: const BoxDecoration(
        color: AppColors.white,
      ),
      clipBehavior: Clip.antiAlias,
      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thời gian bắt đầu cảnh báo:',
              style: textDefaultLight,
            ),
            Text(
              (warning.startTime ?? 0).toDate.toStringFormat(),
              style: headLine4,
              maxLines: 2,
              overflow: TextOverflow.clip,
            ),
            const SizedBox(height: 5),
            const Text(
              'Nội dung cảnh báo:',
              style: textDefaultLight,
            ),
            Text(
              warning.warningMessage?.decodeHtml ?? '',
              style: headLine4,
              maxLines: 3,
              overflow: TextOverflow.clip,
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Text(
                  'Trạng thái:',
                  style: textDefaultLight,
                ),
                const SizedBox(width: 5),
                Text(
                  statusName,
                  style: headLine4,
                  maxLines: 3,
                  overflow: TextOverflow.clip,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  String get statusName {
    final status = warning.status ?? 0;
    switch (status) {
      case 1:
        return 'Cảnh báo mới';
      case 2:
        return 'NV Giám sát tiếp nhận';
      case 3:
        return 'Đang xử lý';
      case 4:
        return 'Được chấp thuận';
      case 5:
        return 'Đã đóng';
      case 6:
        return 'Chưa xử lý trong ngày';
      default:
        return '';
    }
  }
}
