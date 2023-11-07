import 'dart:convert';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/dialog/progress_dialog.dart';
import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/common/snack_bar/error_snack_bar.dart';
import 'package:mvvm_cubit/common/widget/drop_down.dart';
import 'package:mvvm_cubit/common/widget/primary_button.dart';
import 'package:mvvm_cubit/common/widget/text_input.dart';
import 'package:mvvm_cubit/core/api_config.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_string.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/data/model/map_location/map_location_response.dart';
import 'package:mvvm_cubit/data/model/purpose/purpose_response.dart';
import 'package:mvvm_cubit/data/model/temp_form/temp_form_response.dart';
import 'package:mvvm_cubit/data/model/user_role/user_role_response.dart';
import 'package:mvvm_cubit/data/model/vehicle/vehicle_response.dart';
import 'package:mvvm_cubit/data/request/add_trip/add_trip_request.dart';
import 'package:mvvm_cubit/di.dart';
import 'package:mvvm_cubit/viewmodel/add_trip/add_trip_cubit.dart';
import 'package:mvvm_cubit/viewmodel/add_trip/add_trip_state.dart';
import 'package:mvvm_cubit/viewmodel/main/main_cubit.dart';
import 'package:search_choices/search_choices.dart';

class AddTripScreen extends StatefulWidget {
  final TempFormResponse? tempForm;
  final VoidCallback didAddTrip;

  const AddTripScreen({
    super.key,
    this.tempForm,
    required this.didAddTrip,
  });

  @override
  State<StatefulWidget> createState() => _AddTripScreen();
}

class _AddTripScreen extends State<AddTripScreen> {
  final addTripCubit = AddTripCubit(repository: di());
  final mainCubit = MainCubit(repository: di());
  dynamic selectedValueSingleDialogFuture;

  final GlobalKey<State> _progressKey = GlobalKey<State>();

  List<PurposeResponse> _purposes = [];
  List<UserRoleResponse> _drivers = [];
  List<UserRoleResponse> _guards = [];
  List<VehicleResponse> _vehicles = [];
  List<String> _currencies = [];

  PurposeResponse? _purpose;
  int? _amount;
  UserRoleResponse? _driver;
  VehicleResponse? _vehicle;
  UserRoleResponse? _guard;
  MapLocationResponse? _location;
  String? _currency;
  TempFormResponse? _tempForm;

  final _amountController = TextEditingController();

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
    _tempForm = widget.tempForm;

    logger.d('===_tempForm $_tempForm');
    if (_tempForm != null) {
      setState(() {
        _loadEditTempForm(_tempForm!);
      });
    }
  }

  void _loadEditTempForm(TempFormResponse tempForm) {
    _purpose = tempForm.purpose;
    _driver = tempForm.driver;
    _vehicle = tempForm.vehicle;
    _guard = tempForm.bodyguard;
    _location = MapLocationResponse(
      display: tempForm.address?.address,
      lat: tempForm.address?.lat,
      lng: tempForm.address?.lng,
    );
    _currency = tempForm.currency;
    _amount = tempForm.quantity?.toInt();
    logger.d('====message $_amount');
    _amountController.text = _amount.toString();
    selectedValueSingleDialogFuture = tempForm.address?.toJson();
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
          if (state.status == Status.failure) {
            showErrorSnackBar(
              context,
              state.error ?? AppString.sendTimeOut,
            );
          }
          final data = state.data;
          if (state.status == Status.loading) {
            showProgressDialog(context, _progressKey);
          }
          if (data is GetPurposesState) {
            setState(() {
              _purposes = data.purposes;
              if (_tempForm == null) _purpose = _purposes.first;
            });
          } else if (data is GetDriversState) {
            setState(() {
              _drivers = data.drivers;
              if (_tempForm == null) _driver = _drivers.first;
            });
          } else if (data is GetGuardsState) {
            setState(() {
              _guards = data.guards;
              if (_tempForm == null) _guard = _guards.first;
            });
          } else if (data is GetVehiclesState) {
            setState(() {
              _vehicles = data.vehicles;
              if (_tempForm == null) _vehicle = _vehicles.first;
            });
          } else if (data is GetCurrenciesState) {
            setState(() {
              _currencies = data.currencies;
              if (_tempForm == null) _currency = _currencies.first;
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
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        (_tempForm == null)
                                            ? 'Thêm phiếu yêu cầu'
                                            : 'Sửa phiếu yêu cầu',
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
                                      if (_purposes.isNotEmpty)
                                        DropDown<PurposeResponse>(
                                          initialItem: _purpose,
                                          items: _purposes,
                                          displayTextBuilder: (value) =>
                                              value.name ?? '',
                                          onChanged: (value) {
                                            setState(() {
                                              _purpose = value;
                                            });
                                          },
                                        ),
                                      if (_purposes.isEmpty)
                                        const Text(
                                            'Yêu cầu phải chọn Mục đích di chuyển'),
                                      const SizedBox(height: 15),
                                      Column(
                                        children: [
                                          const Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              'Điểm dừng',
                                              style: textDefault,
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                Dimension.radiusDefault,
                                              ),
                                              color: Colors.white,
                                              border: Border.all(
                                                color: AppColors.border,
                                                width: 1.0,
                                              ),
                                            ),
                                            child: search(),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 15),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Flexible(
                                            flex: 2,
                                            child: TextInput(
                                              controller: _amountController,
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
                                              child: Column(
                                                children: [
                                                  const Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                      'Loại tiền',
                                                      style: textDefault,
                                                    ),
                                                  ),
                                                  DropDown<String>(
                                                    initialItem: _currency,
                                                    items: _currencies,
                                                    displayTextBuilder:
                                                        (value) => value,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _currency = value;
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
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
                                          initialItem: _guard,
                                          items: _guards,
                                          displayTextBuilder: (value) =>
                                              value.name ?? '',
                                          onChanged: (value) {
                                            setState(() {
                                              _guard = value;
                                            });
                                          },
                                        ),
                                      if (_guards.isEmpty)
                                        const Text('Yêu cầu phải chọn bảo vệ'),
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
                                          initialItem: _driver,
                                          items: _drivers,
                                          displayTextBuilder: (value) =>
                                              value.name ?? '',
                                          onChanged: (value) {
                                            setState(() {
                                              _driver = value;
                                            });
                                          },
                                        ),
                                      if (_drivers.isEmpty)
                                        const Text('Yêu cầu phải chọn lái xe'),
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
                                          initialItem: _vehicle,
                                          items: _vehicles,
                                          displayTextBuilder: (value) =>
                                              value.plateNumber ?? '',
                                          onChanged: (value) {
                                            setState(() {
                                              _vehicle = value;
                                            });
                                          },
                                        ),
                                      if (_vehicles.isEmpty)
                                        const Text('Yêu cầu phải chọn xe'),
                                      const SizedBox(height: 15),
                                      PrimaryButton(
                                        title: 'Gửi',
                                        buttonHeight: 50,
                                        backgroundColor: validSubmit()
                                            ? AppColors.primary
                                            : AppColors.textDefaultLight,
                                        onPressed: validSubmit()
                                            ? () {
                                                if (_tempForm == null) {
                                                  addTripCubit
                                                      .createTrip(_toRequest);
                                                } else {
                                                  addTripCubit
                                                      .updateTrip(_toRequest);
                                                }
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
            logger.d('===selectedValueSingleDialogFuture $value');
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
          Uri.parse('${ApiConfig.vietMapSearch}$keyword'),
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
        _driver != null &&
        _vehicle != null &&
        _guard != null &&
        _location != null &&
        _currency != null) {
      return true;
    }
    return false;
  }

  AddTripRequest get _toRequest {
    double amount = 0;
    final text = _amountController.text.replaceAll('.', '');
    if (text.isNotEmpty) {
      amount = double.parse(text);
    }
    return AddTripRequest(
      purposeId: _purpose?.id ?? '',
      stopPointAddress: _location?.display ?? '',
      latitude: _location?.lat ?? 0,
      longitude: _location?.lng ?? 0,
      quantity: amount,
      currency: _currency ?? '',
      driverId: _driver?.id ?? '',
      bodyguardId: _guard?.id ?? '',
      vehicleId: _vehicle?.id ?? '',
      note: 'note',
    );
  }
}
