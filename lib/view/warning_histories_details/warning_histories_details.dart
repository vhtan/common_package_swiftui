import 'package:flutter/material.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/data/model/warning_details/warning_details_response.dart';

class WarningHistoriesDetailsScreen extends StatelessWidget {
  final WarningDetailsResponse warning;
  final double _spacing = 5;

  const WarningHistoriesDetailsScreen({
    super.key,
    required this.warning,
  });

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
                            'Chi tiết cảnh báo',
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
                                'Mã cảnh báo: ${warning.id ?? ''}',
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
                            'tempForm.purpose?.name?.decodeHtml ??  ',
                            maxLines: 3,
                            style: textDefault,
                          ),
                          SizedBox(height: _spacing),
                          const Text(
                            'Điểm dừng:',
                            style: textDefaultLight,
                          ),
                          Text(
                            'tempForm.address?.address?.decodeHtml',
                            style: textDefault,
                            maxLines: 4,
                          ),
                          SizedBox(height: _spacing),
                          const Text(
                            'Số tiền',
                            style: textDefaultLight,
                          ),
                          SizedBox(height: _spacing),
                          const Text(
                            'Loại tiền',
                            style: textDefaultLight,
                          ),
                          SizedBox(height: _spacing),
                          const Text(
                            'Bảo vệ',
                            style: textDefaultLight,
                          ),
                          SizedBox(height: _spacing),
                          const Text(
                            'Lái xe',
                            style: textDefaultLight,
                          ),
                          SizedBox(height: _spacing),
                          const Text(
                            'Xe',
                            style: textDefaultLight,
                          ),
                          SizedBox(height: _spacing),
                          Row(
                            children: [
                              const Text(
                                'Trạng thái:',
                                style: textDefaultLight,
                              ),
                              const SizedBox(width: 10),
                            ],
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
}
