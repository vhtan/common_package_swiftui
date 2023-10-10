import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/common/widget/drop_down.dart';
import 'package:mvvm_cubit/common/widget/primary_button.dart';
import 'package:mvvm_cubit/common/widget/text_input.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/di.dart';
import 'package:mvvm_cubit/viewmodel/add_trip/add_trip_cubit.dart';
import 'package:mvvm_cubit/viewmodel/add_trip/add_trip_state.dart';
import 'package:mvvm_cubit/viewmodel/main/main_cubit.dart';
import 'package:search_choices/search_choices.dart';

class AddTripScreen extends StatefulWidget {
  const AddTripScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddTripScreen();
}

class _AddTripScreen extends State<AddTripScreen> {
  final TextEditingController _amountController = TextEditingController();
  final NumberFormat _numberFormat = NumberFormat('#,###');
  final addTripCubit = AddTripCubit(repository: di());
  final mainCubit = MainCubit(repository: di());
  dynamic selectedValueSingleDialogFuture;
  @override
  void initState() {
    super.initState();
    addTripCubit.taskPurposeList();
    addTripCubit.getDriverList();
    addTripCubit.vehicleList();
    addTripCubit.getGuardGuyList();
    _amountController.addListener(
      () {
        final text = _amountController.text;
        final number = _numberFormat.parse(text.replaceAll(',', ''));
        _amountController.value = TextEditingValue(
          text: _numberFormat.format(number),
          selection:
              TextSelection.collapsed(offset: _amountController.text.length),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AddTripCubit>(create: (context) => addTripCubit),
        BlocProvider<MainCubit>(create: (context) => mainCubit)
      ],
      child: BlocConsumer<AddTripCubit, GenericCubitState<AddTripState>>(
        listener: (context, state) {
          // switch (state.status) {
          //   case Status.success:
          //     context.read<MainCubit>().addNewTrip(state.data!.trip!);
          //     Navigator.pop(context);
          //   default:
          //     break;
          // }
        },
        builder: (context, state) {
          return BlocBuilder<AddTripCubit, GenericCubitState<AddTripState>>(
            builder:
                (BuildContext context, GenericCubitState<AddTripState> state) {
              return Material(
                color: Colors.transparent,
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
                                  'Thêm phiếu yêu cầu',
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
                          const SizedBox(height: 20),
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Mục đích di chuyển',
                              style: textDefault,
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (state.data?.purposes != null)
                            DropDown<String>(
                              items: state.data?.purposes
                                      ?.map((e) => e.name ?? '')
                                      .toList() ??
                                  [],
                              onChanged: (value) =>
                                  addTripCubit.reasonChanged(value),
                            ),
                          const SizedBox(height: 20),
                          // TextInput(
                          //   hint: 'Nhập điểm dừng',
                          //   labelText: 'Điểm dừng',
                          //   keyboardType: TextInputType.number,
                          //   onChanged: (value) =>
                          //       addTripCubit.stopPlaceChanged(value),
                          // ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                Dimension.radiusDefault,
                              ),
                              color: Colors.white,
                              border: Border.all(
                                color: AppColors.border,
                                width: 1.0,
                              ),
                            ),
                            child: search(),
                          ),
                          const SizedBox(height: 20),
                          TextInput(
                            hint: 'Nhập số tiền',
                            labelText: 'Số tiền',
                            keyboardType: TextInputType.number,
                            controller: _amountController,
                            onChanged: (value) => addTripCubit.amountChanged(
                              int.parse(value),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Chọn bảo vệ',
                              style: textDefault,
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (state.data?.guards != null)
                            DropDown<String>(
                              items: state.data?.guards
                                      ?.map((e) => e.name ?? '')
                                      .toList() ??
                                  [],
                              onChanged: (value) =>
                                  addTripCubit.guardChanged(value),
                            ),
                          const SizedBox(height: 20),
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Chọn lái xe',
                              style: textDefault,
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (state.data?.drivers != null)
                            DropDown<String>(
                              items: state.data?.drivers
                                      ?.map((e) => e.name ?? '')
                                      .toList() ??
                                  [],
                              onChanged: (value) =>
                                  addTripCubit.driverChanged(value),
                            ),
                          const SizedBox(height: 20),
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Chọn xe',
                              style: textDefault,
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (state.data?.vehicles?.isNotEmpty == true)
                            DropDown<String>(
                              items: state.data?.vehicles
                                      ?.map((e) => e.plateNumber ?? '')
                                      .toList() ??
                                  [],
                              onChanged: (value) =>
                                  addTripCubit.vehicleChanged(value),
                            ),
                          const SizedBox(height: 20),
                          PrimaryButton(
                            title: 'Gửi',
                            buttonHeight: 50,
                            onPressed: state.data?.isValid() == true
                                ? () {
                                    addTripCubit.createTrip();
                                  }
                                : null,
                          )
                        ],
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

  Widget search() {
    return SearchChoices.single(
      style: textDefault,
      underline: null,
      padding: const EdgeInsets.only(top: 2, bottom: 2, left: 10, right: 10),
      displayClearIcon: false,
      icon: null,
      // fieldDecoration: BoxDecoration(
      //   border: Border.all(color: Colors.white),
      // ),
      value: selectedValueSingleDialogFuture,
      hint: 'Điểm dừng',
      searchHint: 'Điểm dừng',
      onChanged: (value) {
        logger.d('onChanged $value');
        setState(
          () {
            selectedValueSingleDialogFuture = 'value';
          },
        );
      },
      isExpanded: true,
      selectedValueWidgetFn: (item) {
        logger.d('selectedValueWidgetFn $item');
        return Center(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: const BorderSide(
                color: Colors.red,
                width: 1,
              ),
            ),
            margin: const EdgeInsets.all(1),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Text(item["capital"]),
            ),
          ),
        );
      },
      futureSearchFn: (String? keyword, String? orderBy, bool? orderAsc,
          List<Tuple2<String, String>>? filters, int? pageNb) async {
        Response response = await get(
          Uri.parse(
              'https://maps.vietmap.vn/api/autocomplete/v3?apikey=12963eff8f160538ffd99bf225440c49a0907f7b7eddda45&text=$keyword'),
        ).timeout(
          const Duration(seconds: 10),
        );
        if (response.statusCode != 200) {
          throw Exception("failed to get data from internet");
        }
        dynamic data = jsonDecode(response.body);
        int nbResults = 1;
        List<DropdownMenuItem> results = (data as List<dynamic>)
            .map<DropdownMenuItem>(
              (item) => DropdownMenuItem(
                value: item,
                child: Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        item['name'],
                        style: textDefault,
                      ),
                      Text(
                        item['display'],
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList();
        return (Tuple2<List<DropdownMenuItem>, int>(results, nbResults));
      },
      emptyListWidget: () => const Text(
        "No result",
        style: TextStyle(
          fontStyle: FontStyle.italic,
          color: Colors.grey,
        ),
      ),
    );
  }
}
