import 'package:dio/dio.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/network/list_response/list_response.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/repository/main/main_repository.dart';

class FaultListCubit extends GenericCubit<FaultListState> {
  final MainRepository repository;

  FaultListCubit({required this.repository});

  Future<void> getFaultList(int page) async {
    emit(
      GenericCubitState.loading(),
    );
    try {
      final listResponse = await repository.getFaultList(page);

      emit(
        GenericCubitState.success(
          GetFaultListState(listResponse: listResponse),
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
  final ListResponse listResponse;
  GetFaultListState({required this.listResponse});
}
