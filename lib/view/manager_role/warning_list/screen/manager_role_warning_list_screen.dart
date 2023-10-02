import 'package:flutter/material.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/view/manager_role/warning_list/widget/manager_role_warning_item.dart';

class ManagerRoleWrningListScreen extends StatefulWidget {
  const ManagerRoleWrningListScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ManagerRoleWrningListScreen();
}

class _ManagerRoleWrningListScreen extends State<ManagerRoleWrningListScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Danh sách cảnh báo'),
          bottom: const TabBar(
            indicatorColor: AppColors.error,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(
                child: Text(
                  'Đang chờ xử lý',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Đã xử lý',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            waitingProcessListView(),
            processedListView(),
          ],
        ),
      ),
    );
  }
}

extension _TabBarView on _ManagerRoleWrningListScreen {
  Widget waitingProcessListView() {
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(
        height: 1,
        color: AppColors.textDefaultLight,
      ),
      shrinkWrap: true,
      itemCount: 10,
      itemBuilder: (_, index) {
        return const ManagerRoleWarningItem(
          isProcessed: false,
        );
      },
    );
  }

  Widget processedListView() {
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(
        height: 1,
        color: AppColors.textDefaultLight,
      ),
      shrinkWrap: true,
      itemCount: 10,
      itemBuilder: (_, index) {
        return const ManagerRoleWarningItem(
          isProcessed: true,
        );
      },
    );
  }
}
