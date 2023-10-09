import 'package:flutter/material.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_style.dart';

class TripInfo extends StatelessWidget {
  final int tripCode;
  final DateTime startDate;
  final String createBy;
  const TripInfo({
    Key? key,
    required this.tripCode,
    required this.startDate,
    required this.createBy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'Mã lộ trình:',
                style: textDefault,
              ),
              const SizedBox(width: 10),
              Text(
                '$tripCode',
                style: textDefault,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text(
                'Thời gian bắt đầu:',
                style: textDefault,
              ),
              const SizedBox(width: 10),
              Text(
                startDate.toStringFormat(),
                style: textDefault,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text(
                'Tạo bởi:',
                style: textDefault,
              ),
              const SizedBox(width: 10),
              Text(
                createBy,
                style: textDefault,
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              Text(
                'Chi tiết lộ trình',
                style: textDefault,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
