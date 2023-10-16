import 'package:dio/dio.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/data/model/purpose/purpose_response.dart';
import 'package:mvvm_cubit/data/model/user_role/user_role_response.dart';
import 'package:mvvm_cubit/data/model/vehicle/vehicle_response.dart';
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
            AddTripState(
              purposes: list,
              purpose: list.first,
            ),
          ),
        );
      } else {
        emit(
          GenericCubitState.success(
            state.data?.copyWith(
              purposes: list,
              purpose: list.first,
            ),
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
            AddTripState(
              vehicles: list,
              vehicle: list.first,
            ),
          ),
        );
      } else {
        emit(
          GenericCubitState.success(
            state.data?.copyWith(
              vehicles: list,
              vehicle: list.first,
            ),
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
            AddTripState(
              drivers: list,
              driver: list.first,
            ),
          ),
        );
      } else {
        emit(
          GenericCubitState.success(
            state.data?.copyWith(
              drivers: list,
              driver: list.first,
            ),
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
            AddTripState(
              guards: list,
              guard: list.first,
            ),
          ),
        );
      } else {
        emit(
          GenericCubitState.success(
            state.data?.copyWith(
              guards: list,
              guard: list.first,
            ),
          ),
        );
      }
    } on DioException catch (e) {
      emit(
        GenericCubitState.failure(e.message ?? 'Error'),
      );
    }
  }

  void reasonChanged(PurposeResponse value) {
    emit(
      GenericCubitState.success(
        state.data?.copyWith(purpose: value),
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

  void driverChanged(UserRoleResponse value) {
    emit(
      GenericCubitState.success(
        state.data?.copyWith(driver: value),
      ),
    );
  }

  void currencyChanged(String value) {
    emit(
      GenericCubitState.success(
        state.data?.copyWith(currency: value),
      ),
    );
  }

  void guardChanged(UserRoleResponse value) {
    emit(
      GenericCubitState.success(
        state.data?.copyWith(guard: value),
      ),
    );
  }

  void vehicleChanged(VehicleResponse value) {
    emit(
      GenericCubitState.success(
        state.data?.copyWith(vehicle: value),
      ),
    );
  }

  Future<void> createTrip() async {
    final request = state.data?.toRequest();
    try {
      if (request != null) {
        final id = await repository.createTrip(request);
        emit(
          GenericCubitState.success(
            state.data?.copyWith(tempForm: id),
          ),
        );
      }
    } on DioException catch (e) {
      emit(
        GenericCubitState.failure(e.message ?? 'Error'),
      );
    }
  }

  Future<void> getMapLocation(String refId) async {
    try {
      final mapLocation = await repository.getMapLocation(refId);
      emit(
        GenericCubitState.success(
          state.data?.copyWith(location: mapLocation),
        ),
      );
    } on DioException catch (e) {
      emit(
        GenericCubitState.failure(e.message ?? 'Error'),
      );
    }
  }

  Future<void> getCurrencyList() async {
    try {
      emit(
        GenericCubitState.loading(),
      );
      final currencies = await repository.getCurrencyList();
      if (state.data == null) {
        emit(
          GenericCubitState.success(
            AddTripState(
              currencies: currencies,
              currency: currencies.first,
            ),
          ),
        );
      } else {
        emit(
          GenericCubitState.success(
            state.data?.copyWith(
              currencies: currencies,
              currency: currencies.first,
            ),
          ),
        );
      }
    } on DioException catch (e) {
      emit(
        GenericCubitState.failure(e.message ?? 'Error'),
      );
    }
  }
}
