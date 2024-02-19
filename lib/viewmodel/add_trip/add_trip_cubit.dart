import 'package:dio/dio.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_string.dart';
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
        GenericCubitState.failure(e.errorMessage),
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
        GenericCubitState.failure(e.errorMessage),
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
        GenericCubitState.failure(e.errorMessage),
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
        GenericCubitState.failure(e.errorMessage),
      );
    }
  }

  Future<void> createTrip(AddTripRequest request) async {
    logger.d('createTrip ${request.toJson()}');
    try {
      final response = await repository.createTrip(request);
      logger.d('==== response $response');
      if (response.code != ErrorCode.SUCCESS) {
        emit(
          GenericCubitState.failure(AppString.canNotCreateTrip),
        );
        return;
      }
      emit(
        GenericCubitState.success(DidAddTripState()),
      );
    } on DioException catch (e) {
      emit(
        GenericCubitState.failure(e.errorMessage),
      );
    }
  }

  Future<void> getMapLocation(String refId) async {
    try {
      final mapLocation = await repository.getMapLocation(refId);
      emit(
        GenericCubitState.success(GetMapLocationSate(location: mapLocation)),
      );
    } on DioException catch (e) {
      emit(
        GenericCubitState.failure(e.errorMessage),
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
        GenericCubitState.failure(e.errorMessage),
      );
    }
  }

  Future<void> updateTrip(AddTripRequest request) async {
    try {
      await repository.updateTrip(request);
      emit(
        GenericCubitState.success(DidAddTripState()),
      );
    } on DioException catch (e) {
      emit(
        GenericCubitState.failure(e.errorMessage),
      );
    }
  }
}
