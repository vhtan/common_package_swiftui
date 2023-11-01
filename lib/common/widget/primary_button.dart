import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final double buttonHeight;
  final VoidCallback? onPressed;
  final Color? backgroundColor;

  const PrimaryButton({
    super.key,
    required this.title,
    required this.buttonHeight,
    required this.onPressed,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: buttonHeight,
      child: FilledButton(
        onPressed: onPressed,
        style: backgroundColor != null
            ? ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(backgroundColor!),
              )
            : null,
        child: Row(
          children: [
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
            const Spacer()
          ],
        ),
      ),
    );
  }
}
