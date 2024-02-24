import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/dialog/progress_dialog.dart';
import 'package:mvvm_cubit/common/network/list_response/list_response.dart';
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
  List<TempFormHistoryResponse> tempFormHistories = [];
  final _scrollController = ScrollController();
  bool _isLast = false;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.getTempFormHistories(_currentPage);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (_isLast == false) {
          _cubit.getTempFormHistories(_currentPage);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
      child: BlocConsumer<TempFormHistoriesCubit, GenericCubitState>(
        listener: (context, state) {
          ListResponse listResponse;
          if (state.data is GetTempFormHistoriesState) {
            listResponse = state.data.listResponse;

            final list =
                parseTempFormHistoryResponseList(listResponse.content ?? []);
            _isLast = listResponse.last ?? false;
            if (listResponse.first == true) {
              _currentPage = 1;
            } else {
              _currentPage = _currentPage + 1;
            }
            setState(() {
              if (listResponse.first == true) {
                tempFormHistories = list;
              } else {
                tempFormHistories.addAll(list);
              }
            });
          }
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
          return BlocBuilder<TempFormHistoriesCubit, GenericCubitState>(
            builder: (context, state) {
              if (tempFormHistories.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(top: 0, bottom: 20),
                  child: RefreshIndicator(
                    edgeOffset: 20,
                    child: ListView.separated(
                      controller: _scrollController,
                      separatorBuilder: (context, index) => const Divider(
                        height: 1,
                        color: AppColors.textDefaultLight,
                      ),
                      shrinkWrap: true,
                      itemCount: tempFormHistories.length,
                      itemBuilder: (_, index) {
                        return InkWell(
                          onTap: () {
                            final item = tempFormHistories[index];
                            final dialog = showDialog(
                              context: context,
                              builder: (context) =>
                                  TempFormHistoryDetailsScreen(tempForm: item),
                              barrierDismissible: false,
                            );
                            dialog.then((value) {});
                          },
                          child: TempFormHistoryItem(
                            tempFormHistoryResponse: tempFormHistories[index],
                          ),
                        );
                      },
                    ),
                    onRefresh: () => _cubit.getTempFormHistories(0),
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
