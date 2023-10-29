import 'package:mvvm_cubit/common/widget/spinkit_indicator.dart';
import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget {
  const ProgressDialog({
    super.key,
    required this.isProgressed,
    this.onPressed,
  });

  final bool isProgressed;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(isProgressed ? 'Xong' : 'Vui lòng đợi'),
          const SizedBox(height: 15),
          isProgressed
              ? const SizedBox()
              : const SpinKitIndicator(type: SpinKitType.circle),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: isProgressed
                ? ElevatedButton(
                    onPressed: onPressed,
                    child: const Text("Success"),
                  )
                : const SizedBox(),
          )
        ],
      ),
    );
  }
}

Future<dynamic> showProgressDialog(BuildContext context, GlobalKey key) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return ProgressDialog(
        key: key,
        isProgressed: false,
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
    },
  );
}
