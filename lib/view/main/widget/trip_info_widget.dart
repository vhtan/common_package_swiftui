import 'package:flutter/material.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/data/model/main/trip/trip_response.dart';
import 'package:url_launcher/url_launcher.dart';

class TripInfo extends StatelessWidget {
  final int tripCode;
  final DateTime startDate;
  final String plateNumber;
  final RoutingPersonRespone? driver;
  final RoutingPersonRespone? bodyguard;

  const TripInfo({
    super.key,
    required this.tripCode,
    required this.startDate,
    required this.plateNumber,
    required this.driver,
    required this.bodyguard,
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
                'Bảo vệ:',
                style: textDefaultLight,
              ),
              const SizedBox(width: 10),
              Text(
                bodyguard?.fullname?.decodeHtml ?? '',
                style: textDefault,
              ),
            ],
          ),
          Row(
            children: [
              TextButton(
                style: ButtonStyle(
                  side: MaterialStateProperty.all(BorderSide.none),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(AppColors.newColor),
                ),
                onPressed: () =>
                    _launchPhone(bodyguard?.mobile?.decodeHtml ?? ''),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.call),
                    const SizedBox(width: 8),
                    Text(
                      bodyguard?.mobile?.decodeHtml ?? '',
                      style: textDefault,
                    ),
                  ],
                ),
              )
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
                driver?.fullname?.decodeHtml ?? '',
                style: textDefault,
              ),
            ],
          ),
          Row(
            children: [
              TextButton(
                style: ButtonStyle(
                  side: MaterialStateProperty.all(BorderSide.none),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(AppColors.newColor),
                ),
                onPressed: () => _launchPhone(driver?.mobile?.decodeHtml ?? ''),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.call),
                    const SizedBox(width: 8),
                    Text(
                      driver?.mobile?.decodeHtml ?? '',
                      style: textDefault,
                    ),
                  ],
                ),
              )
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

  Future<void> _launchPhone(String phone) async {
    if (!await launchUrl(Uri.parse('tel:$phone'))) {
      throw Exception('Could not call to $phone');
    }
  }
}
