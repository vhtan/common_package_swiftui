// ignore_for_file: must_be_immutable

import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/network/list_response/list_response.dart';
import 'package:mvvm_cubit/data/model/warning_details/warning_details_response.dart';

class WarningListState extends GenericCubitState<dynamic> {
  const WarningListState({required super.status});
}

class GetWarningListSuccess extends WarningListState {
  List<WarningDetailsResponse> warnings;
  GetWarningListSuccess({
    required this.warnings,
    required super.status,
  });
}

class DidLogoutWarningListSuccess extends WarningListState {
  const DidLogoutWarningListSuccess({required super.status});
}

class GetTempFormWarningListState extends WarningListState {
  final ListResponse listResponse;
  const GetTempFormWarningListState({
    required this.listResponse,
    required super.status,
  });
}
