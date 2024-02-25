import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/data/model/temp_form/temp_form_response.dart';

class PendingTripBalanceDetailsWidget extends StatelessWidget {
  const PendingTripBalanceDetailsWidget({
    super.key,
    required this.balanceDetails,
  });

  final List<BalanceDetailsResponse> balanceDetails;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: balanceDetails
                .map(
                  (e) => _moneyWidget(
                    e.quantity,
                    e.currency,
                    e.attr,
                  ),
                )
                .toList(),
          ),
        )
      ],
    );
  }

  Widget _moneyWidget(
    double? amount,
    String? currency,
    int? attribute,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.money_sharp),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Số tiền:',
                  style: textDefaultLight,
                ),
                const SizedBox(width: 10),
                Text(
                  '${formatCurrency(amount ?? 0)} $currency',
                  style: textDefault,
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attribute == 1 ? 'Đủ tiên chuẩn' : 'Không đủ tiên chuẩn',
                  style: textDefault,
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        )
      ],
    );
  }

  String formatCurrency(double amount) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'vi_VN', symbol: '');
    return currencyFormatter.format(amount);
  }
}
