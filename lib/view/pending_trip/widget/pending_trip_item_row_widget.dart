import 'package:flutter/material.dart';
import 'package:mvvm_cubit/core/app_style.dart';

class PendingTripItemRowWidget extends StatelessWidget {
  const PendingTripItemRowWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  final Icon icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        icon,
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textDefaultLight,
              ),
              Text(
                description,
                maxLines: 3,
                style: textDefault,
              ),
            ],
          ),
        )
      ],
    );
  }
}
