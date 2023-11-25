import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/dialog/progress_dialog.dart';
import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/common/snack_bar/error_snack_bar.dart';
import 'package:mvvm_cubit/common/widget/empty_widget.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/data/model/temp_form_history/temp_form_history_response.dart';
import 'package:mvvm_cubit/di.dart';
import 'package:mvvm_cubit/view/temp_form_histories/temp_form_history_item.dart';
import 'package:mvvm_cubit/view/temp_form_history_details/temp_form_history_details_screen.dart';
import 'package:mvvm_cubit/viewmodel/temp_form_histories/temp_form_histories_cubit.dart';

class TempFormHistoriesScreen extends StatefulWidget {
  const TempFormHistoriesScreen({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _TempFormHistoriesScreenState();
}

class _TempFormHistoriesScreenState extends State<TempFormHistoriesScreen> {
  final GlobalKey<State> progressKey = GlobalKey<State>();
  final _cubit = TempFormHistoriesCubit(repository: di());
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.getTempFormHistories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
      child: BlocConsumer<TempFormHistoriesCubit, GenericCubitState>(
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
          return BlocBuilder<TempFormHistoriesCubit, GenericCubitState>(
            builder: (context, state) {
              List<TempFormHistoryResponse> list = [];
              if (state.data is GetTempFormHistoriesState) {
                list = state.data.list;
              }
              logger.d('====list $list');
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
                        return InkWell(
                          onTap: () {
                            final item = list[index];
                            final dialog = showDialog(
                              context: context,
                              builder: (context) =>
                                  TempFormHistoryDetailsScreen(tempForm: item),
                              barrierDismissible: false,
                            );
                            dialog.then((value) {});
                          },
                          child: TempFormHistoryItem(
                            tempFormHistoryResponse: list[index],
                          ),
                        );
                      },
                    ),
                  ),
                );
              } else {
                return const EmptyWidget(message: 'Hiện tại chưa PYC tạm');
              }
            },
          );
        },
      ),
    );
  }
}
