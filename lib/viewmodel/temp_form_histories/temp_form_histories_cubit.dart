import 'package:dio/dio.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/network/list_response/list_response.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/repository/main/main_repository.dart';

class TempFormHistoriesCubit extends GenericCubit<TempFormHistoriesState> {
  final MainRepository repository;

  TempFormHistoriesCubit({required this.repository});

  Future<void> getTempFormHistories(int page) async {
    emit(
      GenericCubitState.loading(),
    );
    try {
      final listResponse = await repository.getTempFormHistories(page);

      emit(
        GenericCubitState.success(
          GetTempFormHistoriesState(listResponse: listResponse),
        ),
      );
    } on DioException catch (e) {
      emit(
        GenericCubitState.failure(e.errorMessage),
      );
    }
  }
}

class TempFormHistoriesState {}

class GetTempFormHistoriesState extends TempFormHistoriesState {
  final ListResponse listResponse;
  GetTempFormHistoriesState({required this.listResponse});
}
