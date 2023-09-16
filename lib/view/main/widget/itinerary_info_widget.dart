import 'package:flutter/material.dart';
import 'package:mvvm_cubit/core/app_style.dart';

class ItineraryInfo extends StatelessWidget {
  const ItineraryInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Mã lộ trình:',
                style: textDefault,
              ),
              SizedBox(width: 10),
              Text(
                'LT4019',
                style: textDefault,
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text(
                'Thời gian bắt đầu:',
                style: textDefault,
              ),
              SizedBox(width: 10),
              Text(
                '10:20, 10/09/2023',
                style: textDefault,
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text(
                'Dự kiến hoàn thành:',
                style: textDefault,
              ),
              SizedBox(width: 10),
              Text(
                '15:20, 10/09/2023',
                style: textDefault,
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
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
