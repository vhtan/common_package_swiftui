import 'package:dio/dio.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/logger/logger.dart';
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
      logger.d('getTrip1');
      final response = await repository.api.getTrip();
      logger.d('getTrip2');
      if (response != null) {
        emit(
          GenericCubitState.success(null),
        );
      } else {
        emit(
          GenericCubitState.failure("Error"),
        );
      }
    } on DioException catch (e) {
      print(e.message);
      emit(
        GenericCubitState.failure(e.message ?? 'Error'),
      );
    }
  }

  void addNewTrip(Trip trip) {
    emit(GenericCubitState.success(MainState(pendingTrip: trip, trip: null)));
  }

  void deleteNewTrip() {
    emit(GenericCubitState.success(MainState(pendingTrip: null, trip: null)));
  }

  void editNewTrip() {
    emit(GenericCubitState.success(MainState(pendingTrip: null, trip: null)));
  }
}
