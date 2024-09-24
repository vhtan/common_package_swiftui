import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:camera_camera/camera_camera.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:material_text_fields/utils/extensions.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/dialog/progress_dialog.dart';
import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/common/snack_bar/error_snack_bar.dart';
import 'package:mvvm_cubit/common/widget/drop_down.dart';
import 'package:mvvm_cubit/common/widget/image_capture.dart';
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
  List<MoneyModelWidget> _moneyModelWidgets = [];

  PurposeResponse? _purpose;
  UserRoleResponse? _driver;
  VehicleResponse? _vehicle;
  UserRoleResponse? _guard;
  MapLocationResponse? _location;
  TempFormResponse? _tempForm;
  File? _localFile;
  String? _uploadedImageName;
  String? _uploadedImagePath;

  KeyboardActionsConfig _keyboardActionsConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
      keyboardBarColor: Colors.grey[200],
      nextFocus: false,
      actions: _moneyModelWidgets
          .map(
            (e) => KeyboardActionsItem(focusNode: e.focusNode),
          )
          .toList(),
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
    _moneyModelWidgets = [
      MoneyModelWidget(
        controller: TextEditingController(),
        focusNode: FocusNode(),
        isStandard: true,
        currency: 'VND',
      )
    ];

    logger.d('===_tempForm $_tempForm');
    if (_tempForm != null) {
      setState(() {
        _loadEditTempForm(_tempForm!);
      });
    } else {
      _moneyModelWidgets.first.controller.text = '0';
    }
  }

  void _loadEditTempForm(TempFormResponse tempForm) {
    logger.d('==== tempForm.vehicle ${tempForm.image}');
    _purpose = tempForm.purpose;
    _driver = tempForm.driver;
    _vehicle = tempForm.vehicle;
    _guard = tempForm.bodyguard;
    _uploadedImageName = tempForm.imgName;
    _uploadedImagePath = tempForm.image;
    _location = MapLocationResponse(
      display: tempForm.address?.address?.decodeHtml,
      lat: tempForm.address?.lat,
      lng: tempForm.address?.lng,
    );

    selectedValueSingleDialogFuture = tempForm.address?.toJson();
    if (tempForm.balanceDetails != null) {
      _moneyModelWidgets = tempForm.balanceDetails!.map((e) {
        final controller = TextEditingController();
        controller.text = e.quantity.toString();
        return MoneyModelWidget(
          controller: controller,
          focusNode: FocusNode(),
          isStandard: e.attr == 1 ? true : false,
          currency: e.currency ?? '',
        );
      }).toList();
    }
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
              if (_tempForm == null ||
                  _vehicles.contains(_tempForm?.vehicle) == false) {
                _vehicle = _vehicles.first;
              }
            });
          } else if (data is GetCurrenciesState) {
            setState(() {
              _currencies = data.currencies;
            });
          } else if (data is GetMapLocationSate) {
            setState(() {
              _location = data.location;
            });
          } else if (data is DidAddTripState) {
            widget.didAddTrip();
            Navigator.pop(context);
          } else if (data is UploadImageAddTripSuccess) {
            setState(
              () {
                _uploadedImageName = data.imageResponse?.imageName;
                _localFile = data.file;
              },
            );
          }
        },
        builder: (context, state) {
          return BlocBuilder<AddTripCubit, GenericCubitState<AddTripState>>(
            builder: (context, state) {
              return Scaffold(
                backgroundColor: Colors.transparent,
                body: buildBody(state),
                // body: KeyboardActions(
                //   tapOutsideBehavior: TapOutsideBehavior.opaqueDismiss,
                //   config: _keyboardActionsConfig(context),
                //   child: buildBody(state),
                // ),
              );
            },
          );
        },
      ),
    );
  }

  Widget buildBody(GenericCubitState state) {
    return Container(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 40,
        bottom: 40,
      ),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          padding: const EdgeInsets.only(
            bottom: 20,
            top: 0,
          ),
          child: Column(
            children: [
              _titleWidget,
              Expanded(
                child: SingleChildScrollView(
                  child: _contentWidget,
                ),
              ),
            ],
          )),
    );
  }

  Widget get _titleWidget {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            (_tempForm == null) ? 'Thêm phiếu yêu cầu' : 'Sửa phiếu yêu cầu',
            style: headLine1,
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            color: Colors.black,
            icon: const Icon(
              Icons.close,
              size: 34,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }

  Widget get _contentWidget {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child: Column(
            children: [
              _purposesWidget,
              _stopPointWidget,
            ],
          ),
        ),
        const SizedBox(height: 15),
        ..._moneyModelWidgets.map(
          (e) => _generateMoneyWidget(e),
        ),
        _addMoneyWidget,
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child: Column(
            children: [
              _bodyGuardWidget,
              _driverWidget,
              const SizedBox(height: 15),
              _vehicleWidget,
              const SizedBox(height: 15),
              ImageCapture(
                title: 'Chụp ảnh',
                imageFile: _localFile,
                imagePath: _uploadedImagePath,
                captureCallback: () => openCamera(context),
                deleteCallback: () => {
                  setState(() {
                    _localFile = null;
                    _uploadedImageName = null;
                    _uploadedImagePath = null;
                  })
                },
              ),
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
                          addTripCubit.createTrip(_toRequest);
                        } else {
                          addTripCubit.updateTrip(_toRequest);
                        }
                      }
                    : null,
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget get _purposesWidget {
    return Column(
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
            displayTextBuilder: (value) => value.name?.decodeHtml ?? '',
            // displayTextBuilder: (value) => "dadsads",
            onChanged: (value) {
              setState(() {
                _purpose = value;
              });
            },
          ),
        if (_purposes.isEmpty)
          const Text('Yêu cầu phải chọn Mục đích di chuyển'),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget get _stopPointWidget {
    return Column(
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
        )
      ],
    );
  }

  Widget get _bodyGuardWidget {
    return Column(
      children: [
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
            displayTextBuilder: (value) => value.name?.decodeHtml ?? '',
            onChanged: (value) {
              setState(() {
                _guard = value;
              });
            },
          ),
        if (_guards.isEmpty) const Text('Yêu cầu phải chọn bảo vệ'),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget get _driverWidget {
    return Column(
      children: [
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
            displayTextBuilder: (value) => value.name?.decodeHtml ?? '',
            onChanged: (value) {
              setState(() {
                _driver = value;
              });
            },
          ),
        if (_drivers.isEmpty) const Text('Yêu cầu phải chọn lái xe'),
      ],
    );
  }

  Widget get _vehicleWidget {
    return Column(
      children: [
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
            displayTextBuilder: (value) => value.plateNumber ?? '',
            onChanged: (value) {
              setState(() {
                _vehicle = value;
              });
            },
          ),
        if (_vehicles.isEmpty) const Text('Yêu cầu phải chọn xe'),
      ],
    );
  }

  Widget get _addMoneyWidget {
    return Row(
      children: [
        const Spacer(),
        IconButton(
          onPressed: () => setState(() {
            _moneyModelWidgets.add(
              MoneyModelWidget(
                controller: TextEditingController(),
                focusNode: FocusNode(),
                isStandard: true,
                currency: _currencies.first,
              ),
            );
          }),
          icon: const Row(
            children: [
              Icon(Icons.add),
              Text('Thêm loại tiền'),
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _generateMoneyWidget(
    MoneyModelWidget moneyModelWidget,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                flex: 3,
                child: TextInputCustom(
                  controller: moneyModelWidget.controller,
                  focusNode: moneyModelWidget.focusNode,
                  hint: 'Nhập số tiền',
                  labelText: 'Số tiền',
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      if (value.isEmpty) {
                        // _amount1 = null;
                      } else {
                        // _amount1 = int.parse(value.replaceAll('.', ''));
                      }
                    });
                  },
                  inputFormatters: [
                    CurrencyTextInputFormatter.currency(
                      locale: 'vi',
                      decimalDigits: 0,
                      symbol: '',
                    )
                  ],
                ),
              ),
              const SizedBox(width: 8.0),
              if (_currencies.isNotEmpty)
                Flexible(
                  flex: 2,
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Loại tiền',
                          style: textDefault,
                        ),
                      ),
                      DropDown<String>(
                        initialItem: moneyModelWidget.currency,
                        items: _currencies,
                        displayTextBuilder: (value) => value,
                        onChanged: (value) {
                          setState(() {
                            moneyModelWidget.currency = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              IconButton(
                color: Colors.black,
                icon: const Icon(
                  Icons.close,
                ),
                onPressed: () => setState(() {
                  _moneyModelWidgets.removeWhere(
                    (element) => moneyModelWidget.id == element.id,
                  );
                }),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _standartWidget(
                  text: 'Đủ tiêu chuẩn',
                  isSelected: moneyModelWidget.isStandard,
                  onPressed: () => setState(() {
                    moneyModelWidget.isStandard = true;
                  }),
                ),
                _standartWidget(
                  text: 'Không đủ tiêu chuẩn',
                  isSelected: !moneyModelWidget.isStandard,
                  onPressed: () => setState(() {
                    moneyModelWidget.isStandard = false;
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _standartWidget({
    required VoidCallback? onPressed,
    required String text,
    required bool isSelected,
  }) {
    return TextButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.all(0.0),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
            side: const BorderSide(color: Colors.transparent),
          ),
        ),
        overlayColor: MaterialStateProperty.resolveWith<Color>(
          (states) => Colors.transparent,
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.border,
                width: 3,
              ),
            ),
            child: Center(
              child: Icon(
                isSelected ? Icons.circle : null,
                color: AppColors.primary,
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(text),
        ],
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
        String address = item['address'];
        return Text(
          address.decodeHtml,
          style: textDefault,
          maxLines: 2,
        );
      },
      searchDelay: 300,
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

  void openCamera(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Stack(
            children: [
              CameraCamera(
                resolutionPreset: ResolutionPreset.medium,
                onFile: (file) {
                  if (file.path.isNotNullOrEmpty()) {
                    addTripCubit.didCapturePhoto(file);
                  } else {}
                  Navigator.pop(context);
                },
              ),
              Positioned(
                top: 60,
                left: 16,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  backgroundColor: Colors.black45,
                  child: const Icon(Icons.close),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool validSubmit() {
    if (_purpose != null &&
        _driver != null &&
        _vehicle != null &&
        _guard != null &&
        _location != null &&
        _uploadedImageName != null) {
      return true;
    }
    return false;
  }

  AddTripRequest get _toRequest {
    return AddTripRequest(
      purposeId: _purpose?.id ?? '',
      stopPointAddress: _location?.display ?? '',
      latitude: _location?.lat ?? 0,
      longitude: _location?.lng ?? 0,
      driverId: _driver?.id ?? '',
      bodyguardId: _guard?.id ?? '',
      vehicleId: _vehicle?.id ?? '',
      balanceDetails: _getBalanceDetails,
      imgName: _uploadedImageName ?? '',
    );
  }

  List<BalanceDetail>? get _getBalanceDetails {
    final list = _moneyModelWidgets.where((element) => element.amount > 0);
    if (list.isEmpty) return null;
    return list
        .map(
          (e) => BalanceDetail(
            currency: e.currency,
            quantity: e.amount,
            attribute: e.isStandard ? 1 : 0,
          ),
        )
        .toList();
  }
}

class MoneyModelWidget {
  int id;
  TextEditingController controller;
  FocusNode focusNode;
  bool isStandard;
  String currency;

  MoneyModelWidget({
    required this.controller,
    required this.focusNode,
    required this.isStandard,
    required this.currency,
  }) : id = Random().nextInt(100000);

  int get amount {
    return int.parse(controller.text.replaceAll('.', ''));
  }
}
