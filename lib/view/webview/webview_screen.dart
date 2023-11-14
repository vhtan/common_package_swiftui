import 'package:flutter/material.dart';
import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/config/app_config.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/data/notification_service/notification_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewCustom extends StatefulWidget {
  final int jobRequestId;

  const WebViewCustom({
    super.key,
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
    final url = '${environment.vacomUrl()}${widget.jobRequestId}';
    logger.i('url $url');
    controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    controller.loadRequest(
      Uri.parse(url),
    );

    PushNotificationService().onHandleMessage = (value) {
      if (value.id == '${widget.jobRequestId}') {
        Navigator.pop(context);
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hoàn thành PYC: ${widget.jobRequestId}'),
        leading: const BackButton(
          color: AppColors.white,
        ),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
