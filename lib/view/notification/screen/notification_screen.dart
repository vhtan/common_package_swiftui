import 'package:flutter/material.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/view/notification/widget/notification_item.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NotificationScreen();
}

class _NotificationScreen extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: Container(
        alignment: Alignment.center,
        child: ListView.separated(
          separatorBuilder: (context, index) => const Divider(
            height: 1,
            color: AppColors.textDefaultLight,
          ),
          shrinkWrap: true,
          itemCount: 10,
          itemBuilder: (_, index) {
            return const NotificationItem();
          },
        ),
      ),
    );
  }
}
