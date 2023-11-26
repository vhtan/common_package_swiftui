import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
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
      padding: const EdgeInsets.only(
        top: 10,
        left: 10,
        right: 10,
      ),
      decoration: BoxDecoration(
        color: notification.read == true
            ? AppColors.notificationRead
            : AppColors.notificationUnread,
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning,
            color: AppColors.error,
            size: 40,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (notification.dateCreated ?? 0).toDate.toStringFormat(),
                  style: headLine6,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                ),
                Text(
                  notification.title?.decodeHtml ?? '',
                  style: headLine4,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                ),
                if (notification.message != null)
                  Html(
                    data: notification.message!.decodeHtml,
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
