import 'package:flutter/material.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/data/model/warning_details/warning_details_response.dart';

class SOSHistoryWidget extends StatelessWidget {
  final double _sosHeight = 70;
  final String message;

  const SOSHistoryWidget({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
      decoration: const BoxDecoration(
        color: AppColors.white,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thời gian tạo SOS',
            style: textDefaultLight,
          ),
          Text(
            DateTime.now().toStringFormat(),
            style: headLine4,
            maxLines: 2,
            overflow: TextOverflow.clip,
          ),
          const SizedBox(height: 5),
          const Text(
            'Nội dung SOS:',
            style: textDefaultLight,
          ),
          Text(
            message,
            style: headLine4,
            maxLines: 3,
            overflow: TextOverflow.clip,
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }

  Widget _widgetWithSOS({
    required WarningDetailsResponse? warning,
    required BuildContext context,
  }) {
    final level = warning?.level ?? 1;
    // final level = 3;
    var color = AppColors.warning;
    if (level == 2) {
      color = AppColors.warningHigh;
    } else if (level == 3) {
      color = AppColors.warningRisk;
    } else if (level == 4) {
      color = AppColors.error;
    }
    return Container(
      height: _sosHeight,
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      decoration: BoxDecoration(
        color: color,
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          const SizedBox(width: 10),
          const Icon(
            Icons.warning,
            color: AppColors.red,
            size: 24.0,
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Cảnh báo cấp độ: ${warning?.level ?? 1}',
                  style: headLine7,
                  maxLines: 2,
                  overflow: TextOverflow.clip,
                ),
                Text(
                  warning?.warningMessage?.decodeHtml ?? '',
                  style: textDefault,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Thời gian cảnh báo: ${(warning?.startTime ?? 0).toDate.toStringFormat()}',
                  style: headLine7,
                  maxLines: 2,
                  overflow: TextOverflow.clip,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
