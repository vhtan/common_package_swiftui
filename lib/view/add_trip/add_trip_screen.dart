import 'dart:convert';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/widget/drop_down.dart';
import 'package:mvvm_cubit/common/widget/primary_button.dart';
import 'package:mvvm_cubit/common/widget/text_input.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/data/model/purpose/purpose_response.dart';
import 'package:mvvm_cubit/data/model/user_role/user_role_response.dart';
import 'package:mvvm_cubit/data/model/vehicle/vehicle_response.dart';
import 'package:mvvm_cubit/di.dart';
import 'package:mvvm_cubit/viewmodel/add_trip/add_trip_cubit.dart';
import 'package:mvvm_cubit/viewmodel/add_trip/add_trip_state.dart';
import 'package:mvvm_cubit/viewmodel/main/main_cubit.dart';
import 'package:search_choices/search_choices.dart';

class AddTripScreen extends StatefulWidget {
  final VoidCallback didAddTrip;

  const AddTripScreen({
    Key? key,
    required this.didAddTrip,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddTripScreen();
}

class _AddTripScreen extends State<AddTripScreen> {
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
    addTripCubit.getCurrencyList();
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
          if (state.data?.tempForm != null) {
            widget.didAddTrip();
            Navigator.pop(context);
          }
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
                            DropDown<PurposeResponse>(
                              items: state.data?.purposes ?? [],
                              displayTextBuilder: (value) => value.name ?? '',
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
                          Row(
                            children: [
                              Flexible(
                                flex: 2,
                                child: TextInput(
                                  hint: 'Nhập số tiền',
                                  labelText: 'Số tiền',
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) =>
                                      addTripCubit.amountChanged(
                                          int.parse(value.replaceAll('.', ''))),
                                  inputFormatters: [
                                    CurrencyTextInputFormatter(
                                      locale: 'vi',
                                      decimalDigits: 0,
                                      symbol: '',
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              if (state.data?.currencies != null)
                                Flexible(
                                  flex: 1,
                                  child: DropDown<String>(
                                    items: state.data?.currencies ?? [],
                                    displayTextBuilder: (value) => value,
                                    onChanged: (value) =>
                                        addTripCubit.currencyChanged(value),
                                  ),
                                )
                            ],
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
                            DropDown<UserRoleResponse>(
                              items: state.data?.guards ?? [],
                              displayTextBuilder: (value) => value.name ?? '',
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
                            DropDown<UserRoleResponse>(
                              items: state.data?.drivers ?? [],
                              displayTextBuilder: (value) => value.name ?? '',
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
                            DropDown<VehicleResponse>(
                              items: state.data?.vehicles ?? [],
                              displayTextBuilder: (value) =>
                                  value.plateNumber ?? '',
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
      // padding: const EdgeInsets.only(top: 2, bottom: 2, left: 10, right: 10),
      displayClearIcon: false,

      fieldDecoration: BoxDecoration(
        border: Border.all(color: Colors.white),
      ),
      value: selectedValueSingleDialogFuture,
      hint: 'Điểm dừng',
      searchHint: 'Điểm dừng',
      onChanged: (value) {
        setState(
          () {
            selectedValueSingleDialogFuture = value;
            addTripCubit.getMapLocation(value['ref_id']);
          },
        );
      },
      isExpanded: true,
      selectedValueWidgetFn: (item) {
        return Text(
          item['address'],
          style: textDefault,
          maxLines: 2,
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
