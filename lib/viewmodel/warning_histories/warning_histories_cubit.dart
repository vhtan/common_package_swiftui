import 'package:dio/dio.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/data/model/warning_details/warning_details_response.dart';
import 'package:mvvm_cubit/repository/main/main_repository.dart';

class WarningHistoriesCubit extends GenericCubit<WarningHistoriesState> {
  final MainRepository repository;

  WarningHistoriesCubit({required this.repository});

  void getWarningHistories(int page) async {
    emit(
      GenericCubitState.loading(),
    );
    try {
      final list = await repository.getWarningHistories(page);

      emit(
        GenericCubitState.success(
          GetWarningHistoriesState(list: list),
        ),
      );
    } on DioException catch (e) {
      emit(
        GenericCubitState.failure(e.errorMessage),
      );
    }
  }
}

class WarningHistoriesState {}

class GetWarningHistoriesState extends WarningHistoriesState {
  final List<WarningDetailsResponse> list;
  GetWarningHistoriesState({required this.list});
}
