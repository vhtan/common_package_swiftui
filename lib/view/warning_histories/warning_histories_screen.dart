import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/dialog/progress_dialog.dart';
import 'package:mvvm_cubit/common/snack_bar/error_snack_bar.dart';
import 'package:mvvm_cubit/common/widget/empty_widget.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/data/model/warning_details/warning_details_response.dart';
import 'package:mvvm_cubit/di.dart';
import 'package:mvvm_cubit/view/warning_histories/warning_history_widget.dart';
import 'package:mvvm_cubit/view/warnings_handler/screen/warnings_handler_screen.dart';
import 'package:mvvm_cubit/viewmodel/warning_histories/warning_histories_cubit.dart';

class WarningHistoriesScreen extends StatefulWidget {
  const WarningHistoriesScreen({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _WarningHistoriesScreenState();
}

class _WarningHistoriesScreenState extends State<WarningHistoriesScreen> {
  final GlobalKey<State> progressKey = GlobalKey<State>();
  final _cubit = WarningHistoriesCubit(repository: di());

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.getWarningHistories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
      child: BlocConsumer<WarningHistoriesCubit, GenericCubitState>(
        listener: (context, state) {
          switch (state.status) {
            case Status.failure:
              if (progressKey.currentContext != null) {
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
          return BlocBuilder<WarningHistoriesCubit, GenericCubitState>(
            builder: (context, state) {
              List<WarningDetailsResponse> list = [];
              if (state.data is GetWarningHistoriesState) {
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
                        WarningDetailsResponse item = list[index];
                        bool isCanChat =
                            (item.status ?? 0) > 0 && (item.status ?? 0) < 5;
                        return InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WarningsHandlerScreen(
                                id: item.id ?? '',
                                isCanChat: isCanChat,
                              ),
                            ),
                          ),
                          child: WarningHistoryWidget(
                            warning: item,
                          ),
                        );
                      },
                    ),
                  ),
                );
              } else {
                return const EmptyWidget(message: 'Hiện tại chưa cảnh báo');
              }
            },
          );
        },
      ),
    );
  }
}
