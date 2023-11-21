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
  final _debouncer = _Debouncer(const Duration(milliseconds: 200));

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.buttonHeight,
      child: FilledButton(
        onPressed: widget.onPressed != null
            ? () {
                logger.d('_debouncer run');
                _debouncer.run(() {
                  widget.onPressed!();
                });
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

class _Debouncer {
  final Duration delay;
  Timer? _timer;

  _Debouncer(this.delay);

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }
}
