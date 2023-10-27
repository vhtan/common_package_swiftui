import 'package:dio/dio.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/data/request/add_trip/add_trip_request.dart';
import 'package:mvvm_cubit/repository/add_trip/add_trip_repository.dart';
import 'package:mvvm_cubit/viewmodel/add_trip/add_trip_state.dart';

class AddTripCubit extends GenericCubit<AddTripState> {
  final AddTripRepository repository;

  AddTripCubit({required this.repository});

  Future<void> taskPurposeList() async {
    try {
      emit(
        GenericCubitState.loading(),
      );
      final list = await repository.taskPurposeList();
      emit(
        GenericCubitState.success(
          GetPurposesState(purposes: list),
        ),
      );
    } on DioException catch (e) {
      emit(
        GenericCubitState.failure(e.message ?? 'Error'),
      );
    }
  }

  Future<void> vehicleList() async {
    try {
      emit(
        GenericCubitState.loading(),
      );
      final list = await repository.vehicleList();
      emit(
        GenericCubitState.success(
          GetVehiclesState(vehicles: list),
        ),
      );
    } on DioException catch (e) {
      emit(
        GenericCubitState.failure(e.message ?? 'Error'),
      );
    }
  }

  Future<void> getDriverList() async {
    try {
      emit(
        GenericCubitState.loading(),
      );
      final list = await repository.driverList();
      emit(
        GenericCubitState.success(
          GetDriversState(drivers: list),
        ),
      );
    } on DioException catch (e) {
      emit(
        GenericCubitState.failure(e.message ?? 'Error'),
      );
    }
  }

  Future<void> getGuardGuyList() async {
    try {
      emit(
        GenericCubitState.loading(),
      );
      final list = await repository.guardList();
      emit(
        GenericCubitState.success(
          GetGuardsState(guards: list),
        ),
      );
    } on DioException catch (e) {
      emit(
        GenericCubitState.failure(e.message ?? 'Error'),
      );
    }
  }

  Future<void> createTrip(AddTripRequest request) async {
    try {
      emit(
        GenericCubitState.loading(),
      );
      await repository.createTrip(request);
      emit(
        GenericCubitState.success(DidAddTripState()),
      );
    } on DioException catch (e) {
      emit(
        GenericCubitState.failure(e.message ?? 'Error'),
      );
    }
  }

  Future<void> getMapLocation(String refId) async {
    try {
      emit(
        GenericCubitState.loading(),
      );
      final mapLocation = await repository.getMapLocation(refId);
      emit(
        GenericCubitState.success(GetMapLocationSate(location: mapLocation)),
      );
    } on DioException catch (e) {
      emit(
        GenericCubitState.failure(e.message ?? 'Error'),
      );
    }
  }

  Future<void> getCurrencyList() async {
    try {
      final currencies = await repository.getCurrencyList();
      emit(
        GenericCubitState.success(
          GetCurrenciesState(currencies: currencies),
        ),
      );
    } on DioException catch (e) {
      emit(
        GenericCubitState.failure(e.message ?? 'Error'),
      );
    }
  }
}
