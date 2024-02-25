import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/dialog/progress_dialog.dart';
import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/common/snack_bar/error_snack_bar.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/data/model/sos_history/sos_history_response.dart';
import 'package:mvvm_cubit/di.dart';
import 'package:mvvm_cubit/view/sos_histories/sos_history_widget.dart';
import 'package:mvvm_cubit/view/sos_history_details/sos_history_details_screen.dart';
import 'package:mvvm_cubit/viewmodel/sos_histories/sos_histories_cubit.dart';

class SOSHistoriesScreen extends StatefulWidget {
  const SOSHistoriesScreen({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _SOSHistoriesScreenState();
}

class _SOSHistoriesScreenState extends State<SOSHistoriesScreen> {
  final GlobalKey<State> progressKey = GlobalKey<State>();
  final _scrollController = ScrollController();
  final _cubit = SOSHistoriesCubit(repository: di());
  bool _isLast = false;
  int _currentPage = 0;
  final List<SOSHistoryResponse> _list = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.getSOSHistories(_currentPage);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (_isLast == false) {
          loadMore();
        }
      }
    });
  }

  Future<void> _refreshList() async {
    _isLast = false;
    _currentPage = 0;
    _list.clear();
    _cubit.getSOSHistories(_currentPage);
  }

  void loadMore() {
    _currentPage += 1;
    _cubit.getSOSHistories(_currentPage);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
      child: BlocConsumer<SOSHistoriesCubit, GenericCubitState>(
        listener: (context, state) {
          final data = state.data;
          if (data is GetSOSHistoriesState) {
            if (data.list.isEmpty) {
              _isLast = true;
            } else {
              setState(() {
                _list.addAll(data.list);
              });
            }
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
          return BlocBuilder<SOSHistoriesCubit, GenericCubitState>(
            builder: (context, state) {
              logger.d('===== _list.length ${_list.length}');
              return Padding(
                padding: const EdgeInsets.only(top: 0, bottom: 20),
                child: Container(
                  alignment: Alignment.topCenter,
                  child: RefreshIndicator(
                    child: ListView.separated(
                      controller: _scrollController,
                      separatorBuilder: (context, index) => const Divider(
                        height: 1,
                        color: AppColors.textDefaultLight,
                      ),
                      shrinkWrap: true,
                      itemCount: _list.length,
                      itemBuilder: (_, index) {
                        return InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SOSHistoryDetailsScreen(
                                id: _list[index].id ?? '',
                              ),
                            ),
                          ),
                          child: SOSHistoryWidget(sosHistory: _list[index]),
                        );
                      },
                    ),
                    onRefresh: () => _refreshList(),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
