import 'package:flutter/material.dart';
import 'package:material_text_fields/utils/extensions.dart';
import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/data/model/sos_history/sos_history_response.dart';
import 'package:mvvm_cubit/data/model/warning_details/warning_details_response.dart';

class SOSHistoryWidget extends StatelessWidget {
  final double _sosHeight = 70;
  final SOSHistoryResponse sosHistory;

  const SOSHistoryWidget({
    super.key,
    required this.sosHistory,
  });

  @override
  Widget build(BuildContext context) {
    final level = sosHistory.type ?? 0;
    logger.d('==== level $level');
    // final level = 3;
    var color = AppColors.warning;
    if (level == 1) {
      color = AppColors.warningRisk;
    } else if (level == 2) {
      color = AppColors.error;
    }
    return Container(
      padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
      decoration: BoxDecoration(
        color: color,
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
          if (_sosContent.isNotNullOrEmpty())
            const Text(
              'Nội dung SOS:',
              style: textDefaultLight,
            ),
          if (_sosContent.isNotNullOrEmpty())
            Text(
              _sosContent,
              style: headLine4,
              maxLines: 3,
              overflow: TextOverflow.clip,
            ),
          const SizedBox(height: 5),
          if (sosHistory.note.isNotNullOrEmpty())
            const Text(
              'Mô tả sự cố:',
              style: textDefaultLight,
            ),
          if (sosHistory.note.isNotNullOrEmpty())
            Text(
              sosHistory.note ?? '',
              style: headLine4,
              maxLines: 3,
              overflow: TextOverflow.clip,
            ),
        ],
      ),
    );
  }

  String get _sosContent {
    switch (sosHistory.type) {
      case 2:
        return 'Bị cướp';
      case 1:
        return 'Bị bắt giữ';
      default:
        return sosHistory.reason?.name ?? '';
    }
  }
}
