import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/data/model/fault/fault_response.dart';

class FaultListWidget extends StatelessWidget {
  final FaultResponse fault;

  const FaultListWidget({
    super.key,
    required this.fault,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
      decoration: const BoxDecoration(
        color: AppColors.white,
      ),
      clipBehavior: Clip.antiAlias,
      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thời gian ghi nhận lỗi: ${(fault.dateCreated ?? 0).toDate.toStringFormat()}',
              style: headLine4,
              maxLines: 2,
              overflow: TextOverflow.clip,
            ),
            const SizedBox(height: 5),
            Text(
              fault.title?.decodeHtml ?? '',
              style: headLine4,
              maxLines: 3,
              overflow: TextOverflow.clip,
            ),
            if (fault.body != null)
              Html(
                data: fault.body!.decodeHtml,
              ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
