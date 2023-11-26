import 'package:flutter/material.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_style.dart';

class TripInfo extends StatelessWidget {
  final int tripCode;
  final DateTime startDate;
  final String createBy;
  final String plateNumber;
  final String driverName;

  const TripInfo({
    super.key,
    required this.tripCode,
    required this.startDate,
    required this.createBy,
    required this.plateNumber,
    required this.driverName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'Mã lộ trình:',
                style: textDefaultLight,
              ),
              const SizedBox(width: 10),
              Text(
                '$tripCode',
                style: textDefault,
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Text(
                'Thời gian bắt đầu:',
                style: textDefaultLight,
              ),
              const SizedBox(width: 10),
              Text(
                startDate.toStringFormat(),
                style: textDefault,
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Text(
                'Tạo bởi:',
                style: textDefaultLight,
              ),
              const SizedBox(width: 10),
              Text(
                createBy,
                style: textDefault,
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Text(
                'Lái xe:',
                style: textDefaultLight,
              ),
              const SizedBox(width: 10),
              Text(
                driverName,
                style: textDefault,
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Text(
                'Xe:',
                style: textDefaultLight,
              ),
              const SizedBox(width: 10),
              Text(
                plateNumber,
                style: textDefault,
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              Text(
                'Chi tiết lộ trình',
                style: headLine3,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
