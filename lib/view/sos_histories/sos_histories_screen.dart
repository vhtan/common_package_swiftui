import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
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
  final _cubit = SOSHistoriesCubit(repository: di());
  int _currentPage = 0;

  List<String> _list = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.getWarningHistories(_currentPage);
    });

    _list = [
      'Cướp',
      'Va chạm cần hổ trợ',
      'Khẩn cấp khác',
      'Bị bắt giữ',
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
      child: BlocConsumer<SOSHistoriesCubit, GenericCubitState>(
        listener: (context, state) {
          // switch (state.status) {
          //   case Status.failure:
          //     if (progressKey.currentContext != null) {
          //       Navigator.pop(context);
          //     }
          //     showErrorSnackBar(
          //       context,
          //       state.error ?? '',
          //     );
          //   case Status.loading:
          //     if (progressKey.currentContext == null) {
          //       showProgressDialog(
          //         context,
          //         progressKey,
          //       );
          //     }
          //   default:
          //     if (progressKey.currentContext != null) {
          //       Navigator.pop(context);
          //     }
          // }
        },
        builder: (context, state) {
          return BlocBuilder<SOSHistoriesCubit, GenericCubitState>(
            builder: (context, state) {
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
                    itemCount: _list.length,
                    itemBuilder: (_, index) {
                      return InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SOSHistoryDetailsScreen(
                              id: '',
                              isCanChat: true,
                            ),
                          ),
                        ),
                        child: SOSHistoryWidget(message: _list[index]),
                      );
                    },
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
