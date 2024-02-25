import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mvvm_cubit/common/widget/primary_button.dart';
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
      body: Container(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 40,
          bottom: 40,
        ),
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _title,
              const Spacer(),
              if (notification.message != null)
                Container(
                  height: MediaQuery.sizeOf(context).height - 300,
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      child: Html(
                        data: notification.message!.decodeHtml,
                        style: {
                          'body': Style(
                            textAlign: TextAlign.center,
                            color: AppColors.textDefault,
                            fontSize: FontSize(14.0),
                          ),
                        },
                      ),
                    ),
                  ),
                ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 20,
                ),
                child: PrimaryButton(
                  title: 'Đã đọc',
                  buttonHeight: 50,
                  backgroundColor: AppColors.primary,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
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
        maxLines: 2,
      ),
    );
  }
}
