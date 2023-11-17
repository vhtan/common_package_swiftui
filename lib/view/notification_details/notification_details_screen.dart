import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/data/model/notification/notification_response.dart';

class NotificationDetailsScreen extends StatelessWidget {
  final NotificationResponse notification;

  const NotificationDetailsScreen({
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
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(20),
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
                        'Chi tiết',
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
                if (notification.message != null)
                  Flexible(
                    child: Html(data: notification.message?.decodeHtml),
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
        notification.title!.decodeHtml,
        style: headLine1,
      ),
    );
  }
}
