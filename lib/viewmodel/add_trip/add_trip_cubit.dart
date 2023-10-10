import 'package:dio/dio.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/data/request/add_trip/user_type.dart';
import 'package:mvvm_cubit/repository/add_trip/add_trip_repository.dart';
import 'package:mvvm_cubit/viewmodel/add_trip/add_trip_state.dart';

class AddTripCubit extends GenericCubit<AddTripState> {
  final AddTripRepository repository;

  AddTripCubit({required this.repository});

  Future<void> taskPurposeList() async {
    try {
      final list = await repository.taskPurposeList();
      if (state.data == null) {
        emit(
          GenericCubitState.success(
            AddTripState(purposes: list),
          ),
        );
      } else {
        emit(
          GenericCubitState.success(
            state.data?.copyWith(purposes: list),
          ),
        );
      }
    } on DioException catch (e) {
      emit(
        GenericCubitState.failure(e.message ?? 'Error'),
      );
    }
  }

  Future<void> vehicleList() async {
    try {
      final list = await repository.vehicleList();
      if (state.data == null) {
        emit(
          GenericCubitState.success(
            AddTripState(vehicles: list),
          ),
        );
      } else {
        emit(
          GenericCubitState.success(
            state.data?.copyWith(vehicles: list),
          ),
        );
      }
    } on DioException catch (e) {
      emit(
        GenericCubitState.failure(e.message ?? 'Error'),
      );
    }
  }

  Future<void> getDriverList() async {
    try {
      final list = await repository.driverList();
      if (state.data == null) {
        emit(
          GenericCubitState.success(
            AddTripState(drivers: list),
          ),
        );
      } else {
        emit(
          GenericCubitState.success(
            state.data?.copyWith(drivers: list),
          ),
        );
      }
    } on DioException catch (e) {
      emit(
        GenericCubitState.failure(e.message ?? 'Error'),
      );
    }
  }

  Future<void> getGuardGuyList() async {
    try {
      final list = await repository.guardList();
      if (state.data == null) {
        emit(
          GenericCubitState.success(
            AddTripState(guards: list),
          ),
        );
      } else {
        emit(
          GenericCubitState.success(
            state.data?.copyWith(guards: list),
          ),
        );
      }
    } on DioException catch (e) {
      emit(
        GenericCubitState.failure(e.message ?? 'Error'),
      );
    }
  }

  void reasonChanged(String value) {
    emit(
      GenericCubitState.success(
        state.data?.copyWith(purpose: value),
      ),
    );
  }

  void stopPlaceChanged(String value) {
    emit(
      GenericCubitState.success(
        state.data?.copyWith(stopPlace: value),
      ),
    );
  }

  void amountChanged(int value) {
    emit(
      GenericCubitState.success(
        state.data?.copyWith(amount: value),
      ),
    );
  }

  void driverChanged(String value) {
    emit(
      GenericCubitState.success(
        state.data?.copyWith(driver: value),
      ),
    );
  }

  void guardChanged(String value) {
    emit(
      GenericCubitState.success(
        state.data?.copyWith(guard: value),
      ),
    );
  }

  void vehicleChanged(String value) {
    emit(
      GenericCubitState.success(
        state.data?.copyWith(vehicle: value),
      ),
    );
  }

  void licensePlateChanged(String value) {
    emit(
      GenericCubitState.success(
        state.data?.copyWith(licensePlate: value),
      ),
    );
  }

  Future<void> createTrip() async {}
}
