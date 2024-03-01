import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvvm_cubit/core/app_asset.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/data/model/temp_form/temp_form_response.dart';
import 'package:mvvm_cubit/data/model/temp_form_history/temp_form_history_response.dart';
import 'package:mvvm_cubit/view/pending_trip/widget/pending_trip_balance_details_widget.dart';

class TempFormHistoryDetailsScreen extends StatelessWidget {
  final TempFormHistoryResponse tempForm;
  final double _spacing = 5;
  final _oCcy = NumberFormat("#,##0", "vi_VN");

  TempFormHistoryDetailsScreen({super.key, required this.tempForm});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.center,
            child: IntrinsicHeight(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.only(bottom: 20, top: 10),
                child: Column(
                  children: [
                    Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        const Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Chi tiết phiếu yêu cầu',
                            style: headLine2,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            color: Colors.black,
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Mã PYC tạm: ${tempForm.code ?? ''}',
                                style: textDefault,
                              )
                            ],
                          ),
                          SizedBox(height: _spacing),
                          const Text(
                            'Mục đích di chuyển:',
                            style: textDefaultLight,
                          ),
                          Text(
                            tempForm.purpose?.name?.decodeHtml ?? '',
                            maxLines: 3,
                            style: textDefault,
                          ),
                          SizedBox(height: _spacing),
                          const Text(
                            'Điểm dừng:',
                            style: textDefaultLight,
                          ),
                          Text(
                            tempForm.address?.address?.decodeHtml ?? '',
                            style: textDefault,
                            maxLines: 4,
                          ),
                          SizedBox(height: _spacing),
                          if ((tempForm.balanceDetails ?? []).isNotEmpty)
                            PendingTripBalanceDetailsWidget(
                              balanceDetails: tempForm.balanceDetails ?? [],
                            ),
                          SizedBox(height: _spacing),
                          const Text(
                            'Bảo vệ',
                            style: textDefaultLight,
                          ),
                          Text(
                            tempForm.bodyguard?.name?.decodeHtml ?? '',
                            style: textDefault,
                          ),
                          SizedBox(height: _spacing),
                          const Text(
                            'Lái xe',
                            style: textDefaultLight,
                          ),
                          Text(
                            tempForm.driver?.name?.decodeHtml ?? '',
                            style: textDefault,
                          ),
                          SizedBox(height: _spacing),
                          const Text(
                            'Xe',
                            style: textDefaultLight,
                          ),
                          Text(
                            tempForm.vehicle?.plateNumber?.decodeHtml ?? '',
                            style: textDefault,
                          ),
                          SizedBox(height: _spacing),
                          if (tempForm.image != null)
                            _imageWidget(tempForm.image!),
                          Row(
                            children: [
                              const Text(
                                'Trạng thái:',
                                style: textDefaultLight,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                tempForm.status?.displayName.decodeHtml ?? '',
                                maxLines: 3,
                                style: textDefault,
                              )
                            ],
                          ),
                          if ((tempForm.status == TempFormStatus.REJECTED ||
                                  tempForm.status == TempFormStatus.APPROVED) &&
                              (tempForm.note ?? '').isNotEmpty)
                            Text(
                              '${tempForm.status == TempFormStatus.REJECTED ? 'Lý do từ chối' : 'Lý do được duyệt'}: ${tempForm.note?.decodeHtml ?? ''}',
                              maxLines: 3,
                              style: textDefault,
                            ),
                          Text(
                            'Thời gian tạo: ${tempForm.dateCreated?.toDate.toStringFormat()}',
                            style: textDefaultLight,
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _imageWidget(String path) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        clipBehavior: Clip.antiAlias,
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: CachedNetworkImage(
            fit: BoxFit.fitWidth,
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
}

extension _TempFormStatusDisplay on TempFormStatus {
  String get displayName {
    switch (this) {
      case TempFormStatus.NEW:
        return 'Mới tạo';
      case TempFormStatus.APPROVED:
        return 'Đã duyệt';
      case TempFormStatus.CLOSED:
        return 'Đã đóng';
      case TempFormStatus.CANCELED:
        return 'Đã huỷ';
      case TempFormStatus.REJECTED:
        return 'Từ chối';
    }
  }
}
