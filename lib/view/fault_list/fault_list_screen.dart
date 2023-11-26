import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/dialog/progress_dialog.dart';
import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/common/snack_bar/error_snack_bar.dart';
import 'package:mvvm_cubit/common/widget/empty_widget.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/data/model/fault/fault_response.dart';
import 'package:mvvm_cubit/di.dart';
import 'package:mvvm_cubit/view/fault_list/fault_list_widget.dart';
import 'package:mvvm_cubit/viewmodel/fault_list/fault_list_cubit.dart';

class FaultListScreen extends StatefulWidget {
  const FaultListScreen({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _FaultListScreenState();
}

class _FaultListScreenState extends State<FaultListScreen> {
  final GlobalKey<State> progressKey = GlobalKey<State>();
  final _cubit = FaultListCubit(repository: di());
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.getFaultList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
      child: BlocConsumer<FaultListCubit, GenericCubitState>(
        listener: (context, state) {
          switch (state.status) {
            case Status.failure:
              if (progressKey.currentContext != null) {
                logger.d('message $progressKey');
                Navigator.pop(context);
              }
              showErrorSnackBar(
                context,
                state.error ?? '',
              );

            case Status.loading:
              if (progressKey.currentContext == null) {
                showProgressDialog(
                  context,
                  progressKey,
                );
              }
            default:
              if (progressKey.currentContext != null) {
                Navigator.pop(context);
              }
          }
        },
        builder: (context, state) {
          return BlocBuilder<FaultListCubit, GenericCubitState>(
            builder: (context, state) {
              List<FaultResponse> list = [];
              if (state.data is GetFaultListState) {
                list = state.data.list;
              }
              if (list.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(top: 0, bottom: 20),
                  child: Container(
                    alignment: Alignment.topCenter,
                    child: ListView.separated(
                      separatorBuilder: (context, index) => const Divider(
                        height: 1,
                        color: AppColors.textDefaultLight,
                      ),
                      shrinkWrap: true,
                      itemCount: list.length,
                      itemBuilder: (_, index) {
                        return FaultListWidget(fault: list[index]);
                      },
                    ),
                  ),
                );
              } else {
                return const EmptyWidget(
                    message: 'Hiện tại chưa có lỗi không tuân thủ');
              }
            },
          );
        },
      ),
    );
  }
}
