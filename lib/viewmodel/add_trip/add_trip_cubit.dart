import 'package:dio/dio.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/repository/add_trip/add_trip_repository.dart';
import 'package:mvvm_cubit/viewmodel/add_trip/add_trip_state.dart';

class AddTripCubit extends GenericCubit<AddTripState> {
  final AddTripRepository repository;

  AddTripCubit({required this.repository});

  Future<void> taskPurposeList() async {
    try {
      final list = repository.api.taskPurposeList();
    } on DioException catch (e) {
      emit(
        GenericCubitState.failure(e.message ?? 'Error'),
      );
    }
  }

  Future<void> getVehicleTypeList() async {
    final vehicleTypes = ['Loại xe', 'For', 'Toyota', 'Chevrolet'];
    if (state.data == null) {
      emit(
        GenericCubitState.success(
          AddTripState(vehicleTypes: vehicleTypes),
        ),
      );
    } else {
      emit(
        GenericCubitState.success(
          state.data?.copyWith(
            vehicleTypes: vehicleTypes,
          ),
        ),
      );
    }
  }

  Future<void> getGuardGuyList() async {
    try {
      final list = repository.api.userSearchList();
    } on DioException catch (e) {
      emit(
        GenericCubitState.failure(e.message ?? 'Error'),
      );
    }
  }

  void reasonChanged(String value) {
    emit(
      GenericCubitState.success(
        state.data?.copyWith(reason: value),
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

  void vehicleChanged(String value) {
    emit(
      GenericCubitState.success(
        state.data?.copyWith(vehicle: value),
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

  void licensePlateChanged(String value) {
    emit(
      GenericCubitState.success(
        state.data?.copyWith(licensePlate: value),
      ),
    );
  }

  Future<void> createTrip() async {}
}
