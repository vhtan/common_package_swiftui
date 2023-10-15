import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/repository/main/main_repository.dart';
import 'package:mvvm_cubit/viewmodel/manager_role/warning_list/manager_role_warning_list_state.dart';

class ManagerRoleWarningListCubit extends Cubit<GenericCubitState<dynamic>> {
  final MainRepository repository;

  ManagerRoleWarningListCubit({required this.repository})
      : super(GenericCubitState.loading());

  void getWarningList() async {
    final warnings = await repository.getWarningList();
    try {
      emit(
        GetWarningListSuccess(
          warnings: warnings,
          status: Status.success,
        ),
      );
    } catch (ex) {
      emit(
        GenericCubitState.failure(ex.toString()),
      );
    }
  }
}
