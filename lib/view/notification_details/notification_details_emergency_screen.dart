import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mvvm_cubit/common/widget/primary_button.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/data/model/notification/notification_response.dart';

class NotificationEmergencyDetailsScreen extends StatelessWidget {
  final NotificationResponse notification;

  final String str =
      """<blockquote cite="http://www.worldwildlife.org/who/index.html">
For 60 years, WWF has worked to help people and nature thrive. As the world's leading conservation organization, WWF works in nearly 100 countries. At every level, we collaborate with people around the world to develop and deliver innovative solutions that protect communities, wildlife, and the places in which they live.
</blockquote>""";

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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _title,
                if (notification.message != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Html(
                      data: notification.message!.decodeHtml,
                      // data: str,
                      style: {
                        'body': Style(
                          textAlign: TextAlign.center,
                          color: AppColors.textDefault,
                          fontSize: FontSize(14.0),
                        ),
                      },
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: PrimaryButton(
                    title: 'Đã đọc',
                    buttonHeight: 50,
                    backgroundColor: AppColors.primary,
                    onPressed: () => Navigator.pop(context),
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
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Text(
        notification.title?.decodeHtml ?? '',
        style: headLine1,
      ),
    );
  }
}
