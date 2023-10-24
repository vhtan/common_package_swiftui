import 'dart:convert';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/common/widget/drop_down.dart';
import 'package:mvvm_cubit/common/widget/primary_button.dart';
import 'package:mvvm_cubit/common/widget/text_input.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/data/model/map_location/map_location_response.dart';
import 'package:mvvm_cubit/data/model/purpose/purpose_response.dart';
import 'package:mvvm_cubit/data/model/user_role/user_role_response.dart';
import 'package:mvvm_cubit/data/model/vehicle/vehicle_response.dart';
import 'package:mvvm_cubit/data/request/add_trip/add_trip_request.dart';
import 'package:mvvm_cubit/di.dart';
import 'package:mvvm_cubit/viewmodel/add_trip/add_trip_cubit.dart';
import 'package:mvvm_cubit/viewmodel/add_trip/add_trip_state.dart';
import 'package:mvvm_cubit/viewmodel/main/main_cubit.dart';
import 'package:search_choices/search_choices.dart';

class AddTripScreen extends StatefulWidget {
  final String? tempFormId;
  final VoidCallback didAddTrip;

  const AddTripScreen({
    super.key,
    this.tempFormId,
    required this.didAddTrip,
  });

  @override
  State<StatefulWidget> createState() => _AddTripScreen();
}

class _AddTripScreen extends State<AddTripScreen> {
  final addTripCubit = AddTripCubit(repository: di());
  final mainCubit = MainCubit(repository: di());
  dynamic selectedValueSingleDialogFuture;

  List<PurposeResponse> _purposes = [];
  List<UserRoleResponse> _drivers = [];
  List<UserRoleResponse> _guards = [];
  List<VehicleResponse> _vehicles = [];
  List<String> _currencies = [];
  String? _form;

  PurposeResponse? _purpose;
  int? _amount;
  UserRoleResponse? _driver;
  VehicleResponse? _vehicle;
  UserRoleResponse? _guard;
  MapLocationResponse? _location;
  String? _currency;

  final FocusNode _nodeTextInput = FocusNode();
  KeyboardActionsConfig _keyboardActionsConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
      keyboardBarColor: Colors.grey[200],
      nextFocus: false,
      actions: [
        KeyboardActionsItem(
          focusNode: _nodeTextInput,
        ),
      ],
    );
  }

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
          final data = state.data;
          if (data is GetPurposesState) {
            setState(() {
              _purposes = data.purposes;
              _purpose = _purposes.first;
            });
          } else if (data is GetDriversState) {
            setState(() {
              _drivers = data.drivers;
              _driver = _drivers.first;
            });
          } else if (data is GetGuardsState) {
            setState(() {
              _guards = data.guards;
              _guard = _guards.first;
            });
          } else if (data is GetVehiclesState) {
            setState(() {
              _vehicles = data.vehicles;
              _vehicle = _vehicles.first;
            });
          } else if (data is GetCurrenciesState) {
            setState(() {
              _currencies = data.currencies;
              _currency = _currencies.first;
            });
          } else if (data is GetTempFormState) {
            setState(() {
              _form = data.form;
            });
          } else if (data is GetMapLocationSate) {
            setState(() {
              _location = data.location;
            });
          } else if (data is DidAddTripState) {
            widget.didAddTrip();
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return BlocBuilder<AddTripCubit, GenericCubitState<AddTripState>>(
            builder:
                (BuildContext context, GenericCubitState<AddTripState> state) {
              return Scaffold(
                backgroundColor: Colors.transparent,
                resizeToAvoidBottomInset: true,
                body: KeyboardActions(
                  tapOutsideBehavior: TapOutsideBehavior.opaqueDismiss,
                  config: _keyboardActionsConfig(context),
                  child: Center(
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
                            padding: const EdgeInsets.only(bottom: 20, top: 0),
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
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: Column(
                                    children: [
                                      const Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'Mục đích di chuyển',
                                          style: textDefault,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      if (_purposes.isNotEmpty)
                                        DropDown<PurposeResponse>(
                                          items: _purposes,
                                          displayTextBuilder: (value) =>
                                              value.name ?? '',
                                          onChanged: (value) {
                                            setState(() {
                                              _purpose = value;
                                            });
                                          },
                                        ),
                                      const SizedBox(height: 15),
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
                                      const SizedBox(height: 15),
                                      Row(
                                        children: [
                                          Flexible(
                                            flex: 2,
                                            child: TextInput(
                                              focusNode: _nodeTextInput,
                                              hint: 'Nhập số tiền',
                                              labelText: 'Số tiền',
                                              keyboardType:
                                                  TextInputType.number,
                                              onChanged: (value) {
                                                setState(() {
                                                  _amount = int.parse(value
                                                      .replaceAll('.', ''));
                                                });
                                              },
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
                                          if (_currencies.isNotEmpty)
                                            Flexible(
                                              flex: 1,
                                              child: DropDown<String>(
                                                items: _currencies,
                                                displayTextBuilder: (value) =>
                                                    value,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _currency = value;
                                                  });
                                                },
                                              ),
                                            )
                                        ],
                                      ),
                                      const SizedBox(height: 15),
                                      const Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'Chọn bảo vệ',
                                          style: textDefault,
                                        ),
                                      ),
                                      if (_guards.isNotEmpty)
                                        DropDown<UserRoleResponse>(
                                          items: _guards,
                                          displayTextBuilder: (value) =>
                                              value.name ?? '',
                                          onChanged: (value) {
                                            setState(() {
                                              _guard = value;
                                            });
                                          },
                                        ),
                                      const SizedBox(height: 15),
                                      const Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'Chọn lái xe',
                                          style: textDefault,
                                        ),
                                      ),
                                      if (_drivers.isNotEmpty)
                                        DropDown<UserRoleResponse>(
                                          items: _drivers,
                                          displayTextBuilder: (value) =>
                                              value.name ?? '',
                                          onChanged: (value) {
                                            setState(() {
                                              _driver = value;
                                            });
                                          },
                                        ),
                                      const SizedBox(height: 15),
                                      const Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'Chọn xe',
                                          style: textDefault,
                                        ),
                                      ),
                                      if (_vehicles.isNotEmpty)
                                        DropDown<VehicleResponse>(
                                          items: _vehicles,
                                          displayTextBuilder: (value) =>
                                              value.plateNumber ?? '',
                                          onChanged: (value) {
                                            setState(() {
                                              _vehicle = value;
                                            });
                                          },
                                        ),
                                      const SizedBox(height: 15),
                                      PrimaryButton(
                                        title: 'Gửi',
                                        buttonHeight: 50,
                                        onPressed: validSubmit()
                                            ? () {
                                                addTripCubit
                                                    .createTrip(toRequest());
                                              }
                                            : null,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
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

  Widget search() {
    return SearchChoices.single(
      style: textDefault,
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
        if (keyword?.isEmpty == true) {
          return (Tuple2<List<DropdownMenuItem>, int>([], 0));
        }
        Response response = await get(
          Uri.parse(
              'https://maps.vietmap.vn/api/autocomplete/v3?apikey=12963eff8f160538ffd99bf225440c49a0907f7b7eddda45&text=$keyword'),
        ).timeout(
          const Duration(seconds: 10),
        );
        logger.e('==error ${response.statusCode}');
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
      closeButton: 'Đóng',
      emptyListWidget: () => const Text(
        "Không tìm thấy kết quả",
        style: TextStyle(
          fontStyle: FontStyle.italic,
          color: AppColors.textDefault,
          fontSize: 16,
        ),
      ),
    );
  }

  bool validSubmit() {
    logger.d('validSubmit $_location');
    if (_purpose != null &&
        _amount != null &&
        _driver != null &&
        _vehicle != null &&
        _guard != null &&
        _location != null &&
        _currency != null) {
      return true;
    }
    return false;
  }

  AddTripRequest toRequest() {
    return AddTripRequest(
      purposeId: _purpose?.id ?? '',
      stopPointAddress: _location?.address ?? '',
      latitude: _location?.lat ?? 0,
      longitude: _location?.lng ?? 0,
      quantity: double.parse(_amount?.toString() ?? '0'),
      currency: _currency ?? '',
      driverId: _driver?.id ?? '',
      bodyguardId: _guard?.id ?? '',
      vehicleId: _vehicle?.id ?? '',
      note: 'note',
    );
  }
}
