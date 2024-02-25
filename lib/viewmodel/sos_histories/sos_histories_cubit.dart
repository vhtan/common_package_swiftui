import 'package:dio/dio.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/data/model/sos_history/sos_history_response.dart';
import 'package:mvvm_cubit/repository/main/main_repository.dart';

class SOSHistoriesCubit extends GenericCubit<SOSHistoriesState> {
  final MainRepository repository;

  SOSHistoriesCubit({
    required this.repository,
  });

  void getSOSHistories(int page) async {
    emit(
      GenericCubitState.loading(),
    );
    try {
      final listResponse = await repository.getSOSHistories(page);
      emit(
        GenericCubitState.success(
          GetSOSHistoriesState(list: listResponse),
        ),
      );
    } on DioException catch (e) {
      emit(
        GenericCubitState.failure(e.errorMessage),
      );
    }
  }
}

class SOSHistoriesState {}

class GetSOSHistoriesState extends SOSHistoriesState {
  final List<SOSHistoryResponse> list;

  GetSOSHistoriesState({
    required this.list,
  });
}
