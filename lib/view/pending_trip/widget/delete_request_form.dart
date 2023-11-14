import 'package:flutter/material.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/view/main/widget/finish_temp_form.dart';

Future<dynamic> deleteRequestFormDialog(
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
          side: BorderSide(color: Colors.redAccent, width: 2.0),
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.warning_rounded, color: AppColors.error, size: 40),
            const SizedBox(width: 10),
            Text(title, textAlign: TextAlign.center),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(description),
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
                    'Có',
                    style: textDefault,
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

Future<String?> finishRequestFormDialog(
  BuildContext context,
) {
  Future<dynamic> dialog = showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) {
      return FinishTempForm(
        okAction: (value) {},
      );
    },
  );

  return dialog.then((res) => res);
}
