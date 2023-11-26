import 'package:flutter/material.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/data/model/warning_details/warning_details_response.dart';

class ManagerRoleWarningItem extends StatelessWidget {
  final WarningDetailsResponse warning;
  final bool isProcessed;
  final VoidCallback onTap;

  const ManagerRoleWarningItem({
    super.key,
    required this.warning,
    required this.isProcessed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return warningItem();
  }

  Widget warningItem() {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
      decoration: const BoxDecoration(
        color: AppColors.white,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        child: Row(
          children: [
            const Icon(
              Icons.warning,
              color: AppColors.red,
              size: 24.0,
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Thời gian cảnh báo: ${(warning.startTime ?? 0).toDate.toStringFormat()}',
                    style: headLine6,
                    maxLines: 2,
                    overflow: TextOverflow.clip,
                  ),
                  Text(
                    warning.warningMessage?.decodeHtml ?? '',
                    style: textDefault,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isProcessed ? AppColors.primary : AppColors.error,
              ),
              onPressed: onTap,
              child: Text(
                isProcessed ? 'Đã xử lý' : 'Xử lý',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
