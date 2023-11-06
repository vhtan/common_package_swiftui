import 'package:cached_network_image/cached_network_image.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvvm_cubit/common/widget/primary_button.dart';
import 'package:mvvm_cubit/core/app_asset.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/data/model/main/routing_detail_balance/routing_detail_balance_response.dart';
import 'package:mvvm_cubit/data/model/main/routing_job/routing_job_response.dart';
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
    return renderStopPoint(stopPoint, context);
  }

  Widget renderStopPoint(StopPointResponse stopPoint, BuildContext context) {
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
        if (stopPoint.routingJob != null)
          _routingJob(stopPoint.routingJob!, context),
        if (stopPoint.routingDetailBalances?.isNotEmpty ?? false)
          _routingDetailBalances(stopPoint.routingDetailBalances ?? []),
        if (stopPoint.imagePath != null) const SizedBox(height: 10),
        if (stopPoint.imagePath != null) _imageWidget(stopPoint.imagePath!),
        if (stopPoint.status?.canCheckIn() == true) const SizedBox(height: 20),
        if (stopPoint.status?.canCheckIn() == true) _canCheckInButton(),
        const SizedBox(height: 20),
      ],
    );
  }

  void _copyToClipboard(BuildContext context) {
    FlutterClipboard.copy("${stopPoint.jobRequestId ?? 0}");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã sao chép Mã PYC'),
      ),
    );
  }

  Widget _imageWidget(String path) {
    return Padding(
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
            imageUrl: path,
            placeholder: (context, url) => AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.asset(
                AppAsset.placeHolder,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _canCheckInButton() {
    return Row(
      children: [
        const SizedBox(width: 20),
        Flexible(
          child: PrimaryButton(
            title: stopPoint.imagePath != null ? 'Đã đến nơi' : 'Đến nơi',
            buttonHeight: 50,
            backgroundColor: stopPoint.imagePath != null
                ? AppColors.white
                : AppColors.primary,
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
              backgroundColor: (stopPoint.imagePath != null)
                  ? AppColors.primary
                  : AppColors.textDefaultLight,
              onPressed: (stopPoint.imagePath != null)
                  ? () {
                      onFinished(stopPoint.jobRequestId!);
                    }
                  : null,
            ),
          ),
        const SizedBox(width: 20),
      ],
    );
  }

  Widget _routingJob(RoutingJobResponse routingJob, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 20),
              Text(
                routingJob.placeReceive ?? '',
                style: headLine2,
              ),
              const Spacer(),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 20),
              Text(
                'Mã PYC: ${routingJob.jobRequestId ?? 0}',
                style: headLine3,
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.textDefaultLight,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                ),
                onPressed: () => _copyToClipboard(context),
                child: const Icon(
                  Icons.copy,
                  color: AppColors.textDefault,
                  size: 20,
                ),
              ),
              const Spacer(),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 20),
              Text(
                'Loại PYC: ${routingJob.priorityLevel ?? ''}',
                style: headLine3,
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _routingDetailBalance(RoutingDetailBalanceResponse item) {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 20),
            Text(
              item.attribute ?? '',
              style: headLine2,
            ),
            const Spacer(),
          ],
        ),
        Row(
          children: [
            const SizedBox(width: 20),
            Text(
              'Loại tiền: ${item.currency ?? 'VNĐ'}',
              style: headLine2,
            ),
            const Spacer(),
          ],
        ),
        Row(
          children: [
            const SizedBox(width: 20),
            Text(
              'Số lượng ${formatCurrency(item.quantity ?? 0)}',
              style: headLine2,
            ),
            const Spacer(),
          ],
        ),
      ],
    );
  }

  String formatCurrency(double amount) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'vi_VN', symbol: '');
    return currencyFormatter.format(amount);
  }

  Widget _routingDetailBalances(List<RoutingDetailBalanceResponse> list) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          for (var item in list)
            Container(
              color: Colors.white,
              child: _routingDetailBalance(item),
            ),
        ],
      ),
    );
  }
}
