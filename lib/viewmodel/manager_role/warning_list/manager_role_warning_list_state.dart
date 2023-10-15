// ignore_for_file: must_be_immutable

import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/data/model/warning/warning_response.dart';

class WarningListState extends GenericCubitState<dynamic> {
  const WarningListState({required super.status});
}

class GetWarningListSuccess extends WarningListState {
  List<WarningResponse> warnings;
  GetWarningListSuccess({required this.warnings, required super.status});
}
