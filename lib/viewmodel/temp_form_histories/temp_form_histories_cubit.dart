import 'package:dio/dio.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/data/model/temp_form_history/temp_form_history_response.dart';
import 'package:mvvm_cubit/repository/main/main_repository.dart';

class TempFormHistoriesCubit extends GenericCubit<TempFormHistoriesState> {
  final MainRepository repository;

  TempFormHistoriesCubit({required this.repository});

  void getTempFormHistories() async {
    emit(
      GenericCubitState.loading(),
    );
    try {
      final list = await repository.getTempFormHistories();

      emit(
        GenericCubitState.success(
          GetTempFormHistoriesState(list: list),
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
  final List<TempFormHistoryResponse> list;
  GetTempFormHistoriesState({required this.list});
}
