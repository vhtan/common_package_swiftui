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
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.warning_rounded, color: AppColors.error, size: 40),
            const SizedBox(width: 10),
            Flexible(
              child: Text(title, textAlign: TextAlign.left),
            ),
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
                Expanded(
                  child: TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          side: const BorderSide(color: AppColors.border),
                          borderRadius:
                              BorderRadius.circular(Dimension.radiusDefault),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text(
                      'Không',
                      style: textDefault,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Dimension
                            .radiusDefault), // Set the desired border radius
                      ),
                      backgroundColor: AppColors.primary,
                    ),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: const Text(
                      'Có',
                      style: menuTextStyle,
                    ),
                  ),
                ),
              ],
            ),
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
