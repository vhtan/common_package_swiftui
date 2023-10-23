import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mvvm_cubit/common/widget/primary_button.dart';
import 'package:mvvm_cubit/core/app_asset.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/data/model/main/stop_point/stop_point_response.dart';

class StopPointContainer extends StatelessWidget {
  const StopPointContainer({
    super.key,
    required this.stopPoint,
    required this.onArrived,
    required this.onFinished,
  });

  final StopPointResponse stopPoint;
  final ValueChanged<StopPointResponse> onArrived;
  final ValueChanged<int> onFinished;

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
        if (stopPoint.imagePath != null)
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                clipBehavior: Clip.antiAlias,
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: CachedNetworkImage(
                    fit: BoxFit.fill,
                    imageUrl: stopPoint.imagePath ?? '',
                    placeholder: (context, url) => AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.asset(
                        AppAsset.placeHolder,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                )),
          ),
        const SizedBox(height: 20),
        if (stopPoint.status?.canCheckIn() == true)
          Row(
            children: [
              const SizedBox(width: 20),
              Flexible(
                child: PrimaryButton(
                  title: stopPoint.imagePath != null ? 'Đã đến nơi' : 'Đến nơi',
                  buttonHeight: 50,
                  onPressed: (stopPoint.imagePath != null)
                      ? null
                      : () {
                          onArrived(stopPoint);
                        },
                ),
              ),
              if (stopPoint.jobRequestId != null) const SizedBox(width: 20),
              if (stopPoint.jobRequestId != null)
                Flexible(
                  child: PrimaryButton(
                    title: 'Hoàn thành',
                    buttonHeight: 50,
                    onPressed: (stopPoint.imagePath != null)
                        ? () {
                            onFinished(stopPoint.jobRequestId!);
                          }
                        : null,
                  ),
                ),
              const SizedBox(width: 20),
            ],
          ),
        const SizedBox(height: 20),
      ],
    );
  }
}
