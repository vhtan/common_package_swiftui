import 'package:dio/dio.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/data/model/main/trip.dart';
import 'package:mvvm_cubit/repository/main/main_repository.dart';
import 'package:mvvm_cubit/viewmodel/main/main_state.dart';

class MainCubit extends GenericCubit<MainState> {
  final MainRepository repository;

  MainCubit({required this.repository});

  Future<void> getTrip() async {
    try {
      emit(
        GenericCubitState.loading(),
      );
      final trip = await repository.getTrip();
      emit(
        GenericCubitState.success(MainState(trip: trip)),
      );
    } on DioException catch (e) {
      emit(
        GenericCubitState.failure(e.message ?? 'Error'),
      );
    }
  }

  Future<void> getTempFormDetails() async {
    try {
      emit(
        GenericCubitState.loading(),
      );
      final tempForm = await repository.getTempFormDetails();
      emit(
        GenericCubitState.success(
          MainState(tempForm: tempForm),
        ),
      );
    } on DioException catch (e) {
      emit(
        GenericCubitState.failure(e.message ?? 'Error'),
      );
    }
  }

  void deleteNewTrip() {
    emit(
      GenericCubitState.success(
        MainState(
          tempForm: null,
          trip: null,
        ),
      ),
    );
  }

  void editNewTrip() {
    emit(
      GenericCubitState.success(
        MainState(
          tempForm: null,
          trip: null,
        ),
      ),
    );
  }
}
