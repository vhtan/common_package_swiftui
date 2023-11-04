import 'package:flutter/material.dart';
import 'package:mvvm_cubit/core/app_extension.dart';

class NotificationPopupDialog extends StatelessWidget {
  const NotificationPopupDialog({
    super.key,
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: AppColors.error, width: 2.0),
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      title: Row(
        children: [
          const Icon(
            Icons.warning_sharp,
            color: AppColors.error,
            size: 50,
          ),
          const SizedBox(width: 10),
          Text(title),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            description,
            style: const TextStyle(fontSize: 20),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(width: 15),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Đóng"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
