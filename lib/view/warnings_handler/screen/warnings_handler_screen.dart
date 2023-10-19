import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/widget/primary_button.dart';
import 'package:mvvm_cubit/common/widget/text_input.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/data/model/warning_details/warning_details_response.dart';
import 'package:mvvm_cubit/data/request/warning_process/warning_process_request.dart';
import 'package:mvvm_cubit/di.dart';
import 'package:mvvm_cubit/viewmodel/manager_role/manager_warnings_handler/manager_warnings_handler_state.dart';
import 'package:mvvm_cubit/viewmodel/warnings_handler/warnings_handler_cubit.dart';

class WarningsHandlerScreen extends StatefulWidget {
  final String id;
  const WarningsHandlerScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WarningsHandlerScreen();
}

class _WarningsHandlerScreen extends State<WarningsHandlerScreen> {
  final cubit = WarningsHandlerCubit(repository: di());
  String? comment;

  @override
  void initState() {
    super.initState();
    cubit.getWarningDetails(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: BlocConsumer<WarningsHandlerCubit, GenericCubitState>(
        listener: (context, state) {
          if (state is ProcessWarningSuccess) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return BlocBuilder<WarningsHandlerCubit, GenericCubitState>(
            builder: (context, state) {
              WarningDetailsResponse? details;
              if (state is GetWarningDetailsSuccess) {
                details = state.warningDetails;
              }
              return Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: Colors.transparent,
                body: Center(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      alignment: Alignment.center,
                      child: IntrinsicHeight(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 20, top: 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Stack(
                                alignment: AlignmentDirectional.center,
                                children: [
                                  const Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Cảnh báo',
                                      style: headLine1,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      color: Colors.black,
                                      icon: const Icon(Icons.close),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10.0),
                              Row(
                                children: [
                                  Text(
                                    details?.warningMessage ?? '',
                                    style: headLine4,
                                  ),
                                  const Spacer(),
                                ],
                              ),
                              const SizedBox(height: 20.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Hệ thống',
                                    style: headLine6,
                                  ),
                                  const Spacer(),
                                  Text(
                                    (details?.dateCreated ?? 0)
                                        .date
                                        .toStringFormat(),
                                    style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              systemWarning(details?.level),
                              // const SizedBox(height: 20.0),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.start,
                              //   children: [
                              //     Text(
                              //       '${details?.pic?.role?.name ?? ''} - ${details?.pic?.name ?? ''}',
                              //       style: headLine6,
                              //     ),
                              //   ],
                              // ),
                              // Row(
                              //   children: [
                              //     const Spacer(),
                              //     Text(
                              //       details?.pic?.dateCreated?.date
                              //               .toStringFormat() ??
                              //           '',
                              //       style: const TextStyle(
                              //         fontStyle: FontStyle.italic,
                              //         fontSize: 10,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              // normalWarning(),
                              const SizedBox(height: 20.0),
                              TextInput(
                                hint: 'Nhập ý kiến',
                                labelText: 'Nhập ý kiến',
                                maxLines: 3,
                                keyboardType: TextInputType.multiline,
                                onChanged: (value) => {
                                  setState(
                                    () {
                                      comment = value;
                                    },
                                  )
                                },
                              ),
                              const SizedBox(height: 20),
                              PrimaryButton(
                                title: 'Gửi',
                                buttonHeight: 50,
                                onPressed: () => cubit.warningProcess(
                                  WarningProcessRequest(
                                      warningId: widget.id,
                                      action: 'explain',
                                      message: comment ?? ''),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget systemWarning(int? level) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          // color: AppColors.warningHigh,
          // borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        child: Row(
          children: [
            const Icon(
              Icons.settings,
              color: AppColors.red,
              size: 24.0,
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Text(
                'Hệ thống gửi cảnh báo cấp $level',
                style: textDefault,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget normalWarning() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          // color: AppColors.warningHigh,
          // borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        child: const Row(
          children: [
            Icon(
              Icons.request_quote,
              color: AppColors.red,
              size: 24.0,
            ),
            SizedBox(width: 8.0),
            Expanded(
              child: Text(
                'Yêu cầu giải trình',
                style: textDefault,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
