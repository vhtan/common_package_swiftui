import 'package:flutter/material.dart';
import 'package:mvvm_cubit/common/widget/primary_button.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/view/add_trip/add_trip_screen.dart';
import 'package:mvvm_cubit/view/pending_trip/widget/delete_request_form.dart';

class PendingTripScreen extends StatefulWidget {
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const PendingTripScreen({
    Key? key,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PendingTripScreen();
}

class _PendingTripScreen extends State<PendingTripScreen> {
  late VoidCallback _onDelete;
  late VoidCallback _onEdit;

  @override
  void initState() {
    _onDelete = widget.onDelete;
    _onEdit = widget.onEdit;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [
            Text(
              'Phiếu yêu cầu tạm:',
              style: textDefault,
            ),
            SizedBox(width: 10),
            Text(
              '000012',
              style: textDefault,
            ),
          ],
        ),
        const SizedBox(height: 10),
        const ItemRowWidget(
          icon: Icon(Icons.map),
          title: 'Điểm đến:',
          description:
              'Chi nhánh Nam Sai Gòn, 123 Nguyễn Văn Linh, Tân Thuận Tây, Quận 7, Thành phố Hồ Chí Minh',
        ),
        const SizedBox(height: 10),
        const ItemRowWidget(
          icon: Icon(Icons.tag),
          title: 'Mục đích:',
          description: 'Gặp khách hàng',
        ),
        const SizedBox(height: 10),
        const ItemRowWidget(
          icon: Icon(Icons.drive_eta),
          title: 'Lái xe:',
          description: 'Nguyễn Văn A',
        ),
        const SizedBox(height: 10),
        const ItemRowWidget(
          icon: Icon(Icons.security),
          title: 'Bảo vệ:',
          description: 'Nguyễn Văn B',
        ),
        const SizedBox(height: 10),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.security),
            SizedBox(width: 10),
            Flexible(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trạng thái:',
                  style: textDefaultLight,
                ),
                Text(
                  'Chờ duyệt',
                  maxLines: 3,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ))
          ],
        ),
        // const SizedBox(height: 10),
        // const Row(
        //   children: [
        //     Text(
        //       'Dự kiến hoàn thành:',
        //       style: textDefault,
        //     ),
        //     SizedBox(width: 10),
        //     Text(
        //       '15:20, 10/09/2023',
        //       style: textDefault,
        //     ),
        //   ],
        // ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: PrimaryButton(
                title: 'Sửa PYC',
                buttonHeight: 50,
                // onPressed: () => showDialog(
                //   context: context,
                //   builder: (context) => const AddTripScreen(),
                //   barrierDismissible: false,
                // ),
                onPressed: _onEdit,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: PrimaryButton(
                title: 'Huỷ PYC',
                buttonHeight: 50,
                onPressed: () async {
                  bool delete = await deleteRequestFormDialog(
                    'Xoá phiếu yêu cầu',
                    'Bạn có chắc là muốn xoá phiếu yêu cầu',
                    context,
                  );
                  if (delete) {
                    _onDelete();
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ItemRowWidget extends StatelessWidget {
  const ItemRowWidget({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
  }) : super(key: key);

  final Icon icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        icon,
        const SizedBox(width: 10),
        Flexible(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: textDefaultLight,
            ),
            Text(
              description,
              maxLines: 3,
              style: textDefault,
            ),
          ],
        ))
      ],
    );
  }
}
