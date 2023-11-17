import 'package:flutter/material.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/data/model/warning/warning_response.dart';

class ManagerRoleWarningItem extends StatelessWidget {
  final WarningResponse warning;
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
            const SizedBox(width: 8.0), // Add spacing between elements
            Expanded(
              child: Text(
                warning.warningMessage?.decodeHtml ?? '',
                style: textDefault,
                maxLines: 3,
                overflow: TextOverflow.ellipsis, // Specify an overflow property
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isProcessed ? AppColors.primary : AppColors.error,
              ),
              onPressed: onTap,
              child: Text(
                isProcessed ? 'Đã xử lý' : 'Cần xử lý',
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
