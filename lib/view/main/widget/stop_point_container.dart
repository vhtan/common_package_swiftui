import 'package:flutter/material.dart';
import 'package:mvvm_cubit/common/widget/primary_button.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/data/model/main/stop_point/stop_point_response.dart';

class StopPointContainer extends StatelessWidget {
  const StopPointContainer({
    Key? key,
    required this.stopPoint,
    required this.onPressed,
  }) : super(key: key);

  final StopPointResponse stopPoint;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    // if (duty is PickUpDuty) {
    //   PickUpDuty pickUp = duty as PickUpDuty;
    //   return renderPickUpDuty(pickUp);
    // } else if (duty is DeliveryDuty) {
    //   DeliveryDuty request = duty as DeliveryDuty;
    //   return renderDeliveryDuty(request);
    // } else {
    //   return const EmptyWidget(message: 'message');
    // }

    return renderStopPoint(stopPoint);
  }

  Widget renderStopPoint(StopPointResponse stopPoint) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: [
              const Icon(Icons.map),
              const SizedBox(width: 10),
              Expanded(
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
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: [
              const Icon(Icons.phone),
              const SizedBox(width: 10),
              Text(
                stopPoint.stopPointAction ?? '',
                style: textDefault,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: PrimaryButton(
            title: 'Đến nói',
            buttonHeight: 50,
            onPressed: onPressed,
          ),
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
