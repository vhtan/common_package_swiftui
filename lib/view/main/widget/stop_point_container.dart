import 'package:flutter/material.dart';
import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/common/widget/primary_button.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/data/model/main/stop_point/stop_point_response.dart';

class StopPointContainer extends StatelessWidget {
  const StopPointContainer({
    Key? key,
    required this.stopPoint,
    required this.onArrived,
    required this.onFinished,
  }) : super(key: key);

  final StopPointResponse stopPoint;
  final VoidCallback onArrived;
  final VoidCallback onFinished;

  @override
  Widget build(BuildContext context) {
    return renderStopPoint(stopPoint);
  }

  Widget renderStopPoint(StopPointResponse stopPoint) {
    return Column(
      children: [
        const Divider(height: 1, color: AppColors.border, thickness: 1),
        const SizedBox(height: 20),
        Row(
          children: [
            const SizedBox(width: 20),
            Text(
              stopPoint.stopPointType ?? '',
              style: headLine2,
            ),
            const Spacer(),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: [
              const Icon(Icons.map),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  stopPoint.destination?.address ?? '',
                  style: textDefault,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const SizedBox(width: 20),
            Flexible(
              child: PrimaryButton(
                title: 'Đến nơi',
                buttonHeight: 50,
                onPressed: () {
                  logger.d('Đến nơi ${stopPoint.id}');
                },
              ),
            ),
            const SizedBox(width: 20),
            Flexible(
              child: PrimaryButton(
                title: 'Hoàn thành',
                buttonHeight: 50,
                onPressed: () {
                  logger.d('Hoàn thành ${stopPoint.id}');
                },
              ),
            ),
            const SizedBox(width: 20),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // Widget renderDeliveryDuty(DeliveryDuty duty) {
  //   return Column(
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.only(left: 20, right: 20),
  //         child: Row(
  //           children: [
  //             const Icon(Icons.api_sharp),
  //             const SizedBox(width: 10),
  //             Text(
  //               duty.requestFormId,
  //               style: textDefault,
  //             ),
  //           ],
  //         ),
  //       ),
  //       const SizedBox(height: 10),
  //       Padding(
  //         padding: const EdgeInsets.only(left: 20, right: 20),
  //         child: Row(
  //           children: [
  //             const Icon(Icons.money_rounded),
  //             const SizedBox(width: 10),
  //             Text(
  //               duty.totalAmount,
  //               style: textDefault,
  //             ),
  //           ],
  //         ),
  //       ),
  //       const SizedBox(height: 10),
  //       Padding(
  //         padding: const EdgeInsets.only(left: 20, right: 20),
  //         child: Row(
  //           children: [
  //             const Icon(Icons.account_balance),
  //             const SizedBox(width: 10),
  //             Text(
  //               duty.type,
  //               style: textDefault,
  //             ),
  //           ],
  //         ),
  //       ),
  //       const SizedBox(height: 10),
  //       Padding(
  //         padding: const EdgeInsets.only(left: 20, right: 20),
  //         child: PrimaryButton(
  //           title: duty.buttonTitle,
  //           buttonHeight: 50,
  //           onPressed: onPressed,
  //         ),
  //       ),
  //       const SizedBox(height: 20),
  //     ],
  //   );
  // }
}
