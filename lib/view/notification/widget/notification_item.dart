import 'package:flutter/material.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/data/model/notification/notification_response.dart';

class NotificationItem extends StatelessWidget {
  final NotificationResponse notification;

  const NotificationItem({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: AppColors.notificationRead,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
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
                  (notification.dateCreated ?? 0).date.toStringFormat(),
                  style: headLine6,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                ),
                Text(
                  notification.title ?? '',
                  style: headLine4,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                ),
                Text(
                  notification.message ?? '',
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
