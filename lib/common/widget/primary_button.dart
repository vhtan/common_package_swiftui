import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mvvm_cubit/common/logger/logger.dart';

class PrimaryButton extends StatefulWidget {
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
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  final Duration _throttleDuration = const Duration(milliseconds: 40);
  bool _isButtonEnabled = true;

  void _throttleFunction() {
    setState(() {
      _isButtonEnabled = false;
    });

    Timer(_throttleDuration, () {
      setState(() {
        _isButtonEnabled = true;
      });
    });
    logger.d('======onPressed');
    widget.onPressed!();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.buttonHeight,
      child: FilledButton(
        onPressed: (widget.onPressed != null && _isButtonEnabled)
            ? () {
                logger.d('======_isButtonEnabled $_isButtonEnabled');
                _throttleFunction();
              }
            : null,
        style: widget.backgroundColor != null
            ? ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(widget.backgroundColor!),
              )
            : null,
        child: Row(
          children: [
            const Spacer(),
            Text(
              widget.title,
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
