import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/dialog/progress_dialog.dart';
import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/common/network/list_response/list_response.dart';
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
  List<FaultResponse> faultList = [];
  final _scrollController = ScrollController();
  bool _isLast = false;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.getFaultList(_currentPage);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (_isLast == false) {
          _cubit.getFaultList(_currentPage);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
      child: BlocConsumer<FaultListCubit, GenericCubitState>(
        listener: (context, state) {
          ListResponse listResponse;
          if (state.data is GetFaultListState) {
            listResponse = state.data.listResponse;

            final list = parseFaultResponseList(listResponse.content ?? []);
            _isLast = listResponse.last ?? false;
            if (listResponse.first == true) {
              _currentPage = 1;
            } else {
              _currentPage = _currentPage + 1;
            }
            setState(() {
              if (listResponse.first == true) {
                faultList = list;
              } else {
                faultList.addAll(list);
              }
            });
          }
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
              if (faultList.isNotEmpty) {
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
                      itemCount: faultList.length,
                      itemBuilder: (_, index) {
                        return FaultListWidget(fault: faultList[index]);
                      },
                    ),
                    onRefresh: () => _cubit.getFaultList(0),
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
