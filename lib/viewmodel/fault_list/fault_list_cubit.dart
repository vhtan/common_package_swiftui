import 'package:dio/dio.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/data/model/fault/fault_response.dart';
import 'package:mvvm_cubit/repository/main/main_repository.dart';

class FaultListCubit extends GenericCubit<FaultListState> {
  final MainRepository repository;

  FaultListCubit({required this.repository});

  void getFaultList() async {
    emit(
      GenericCubitState.loading(),
    );
    try {
      final list = await repository.getFaultList();

      emit(
        GenericCubitState.success(
          GetFaultListState(list: list),
        ),
      );
    } on DioException catch (e) {
      emit(
        GenericCubitState.failure(e.errorMessage),
      );
    }
  }
}

class FaultListState {}

class GetFaultListState extends FaultListState {
  final List<FaultResponse> list;
  GetFaultListState({required this.list});
}
