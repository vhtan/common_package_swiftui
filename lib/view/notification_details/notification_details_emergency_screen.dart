import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/data/model/notification/notification_response.dart';

class NotificationEmergencyDetailsScreen extends StatelessWidget {
  final NotificationResponse notification;

  const NotificationEmergencyDetailsScreen({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          alignment: Alignment.center,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.error,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(8),
              color: AppColors.white,
            ),
            padding: const EdgeInsets.all(0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        '',
                        style: headLine1,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        color: Colors.black,
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
                _title,
                const SizedBox(height: 20.0),
                Flexible(
                  child: Html(
                    data: notification.message,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget get _title {
    return Align(
      alignment: Alignment.center,
      child: Text(
        notification.title ?? '',
        style: headLine1,
      ),
    );
  }
}
