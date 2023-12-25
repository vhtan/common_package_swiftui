import 'package:flutter/material.dart';
import 'package:mvvm_cubit/core/app_extension.dart';

void showErrorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: <Widget>[
          const Icon(
            Icons.error_outline,
            color: AppColors.white,
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              message,
              maxLines: 4,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.white,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.error,
      duration: const Duration(seconds: 3),
    ),
  );
}

void showConfirmSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: <Widget>[
          const Icon(
            Icons.check,
            color: AppColors.white,
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              message,
              maxLines: 2,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.white,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.primary,
      duration: const Duration(seconds: 3),
    ),
  );
}
