import 'package:flutter/material.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_style.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: AppColors.notificationRead,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      clipBehavior: Clip.antiAlias,
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning,
            color: AppColors.error,
            size: 40,
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hôm nay, 10:20',
                  style: headLine6,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                ),
                Text(
                  'Thông báo từ công ty',
                  style: headLine4,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                ),
                Text(
                  'Ngân hàng Nhà nước: Lãi suất cho vay sẽ tiếp tục giảm',
                  style: textDefault,
                  maxLines: 2,
                  overflow: TextOverflow.clip,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
