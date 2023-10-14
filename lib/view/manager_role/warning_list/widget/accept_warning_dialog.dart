import 'package:flutter/material.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_style.dart';

Future<dynamic> showAcceptWarningDialog(
  String title,
  String description,
  BuildContext context,
) {
  Future<dynamic> dialog = showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.redAccent,
            width: 2.0,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.warning_rounded,
              color: AppColors.error,
              size: 40,
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(title, textAlign: TextAlign.left),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(description),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text(
                    'Không',
                    style: textDefault,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text(
                    'Chấp nhận',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.white,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      );
    },
  );

  return dialog.then((res) => res ?? false);
}
