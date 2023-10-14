import 'package:flutter/material.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewCustom extends StatefulWidget {
  final String title;
  final String url;

  const WebViewCustom({
    Key? key,
    required this.title,
    required this.url,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WebViewCustomState();
}

class _WebViewCustomState extends State<WebViewCustom> {
  final controller = WebViewController();

  @override
  void initState() {
    super.initState();
    controller.loadRequest(
      Uri.parse(widget.url),
    );
  }

  @override
  Widget build(BuildContext context) {
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
