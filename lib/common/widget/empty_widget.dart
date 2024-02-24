import 'package:mvvm_cubit/core/app_asset.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Image.asset(
            AppAsset.emptyState,
            height: 200,
          ),
          Text(
            message,
            style: headLine2,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
