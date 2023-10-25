import 'package:flutter/material.dart';
import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/config/app_config.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/data/notification_service/notification_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewCustom extends StatefulWidget {
  final String title;
  final int jobRequestId;

  const WebViewCustom({
    super.key,
    required this.title,
    required this.jobRequestId,
  });

  @override
  State<StatefulWidget> createState() => _WebViewCustomState();
}

class _WebViewCustomState extends State<WebViewCustom> {
  final controller = WebViewController();

  @override
  void initState() {
    super.initState();
    controller.loadRequest(
      Uri.parse('${environment.vacomUrl()}${widget.jobRequestId}'),
    );

    PushNotificationService().onHandleMessage = (value) {
      if (value == '${widget.jobRequestId}') {
        Navigator.pop(context);
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    Route<dynamic>? currentRoute = ModalRoute.of(context);
    logger.d('name == $currentRoute');
    if (currentRoute is MaterialPageRoute) {
      logger.d('name == ${currentRoute.settings.name}');
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: const BackButton(
          color: AppColors.white,
        ),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
