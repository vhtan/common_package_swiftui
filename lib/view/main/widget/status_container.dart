import 'package:mvvm_cubit/data/model/main/delivery.dart';
import 'package:flutter/material.dart';

class StatusContainer extends StatelessWidget {
  const StatusContainer({Key? key, required this.status}) : super(key: key);

  final DeliveryStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: status == DeliveryStatus.notStarted
            ? const Color(0xFFbac4d6)
            : const Color(0xFFeaedf2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: status == DeliveryStatus.completed
                  ? const Color(0xffc5d0e3)
                  : const Color(0xFF7d90b2),
            ),
            width: 15,
            height: 15,
          ),
          const SizedBox(width: 2),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              status.name,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: status == DeliveryStatus.missingInfo
                      ? Colors.grey
                      : Colors.black87),
            ),
          )
        ],
      ),
    );
  }
}
