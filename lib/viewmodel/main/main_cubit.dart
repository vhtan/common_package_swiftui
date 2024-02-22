import 'package:dio/dio.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/data/model/temp_form/temp_form_response.dart';
import 'package:mvvm_cubit/data/request/check_in/check_in_request.dart';
import 'package:mvvm_cubit/repository/main/main_repository.dart';
import 'package:mvvm_cubit/viewmodel/main/main_state.dart';

class MainCubit extends GenericCubit<MainState> {
  final MainRepository repository;

  MainCubit({required this.repository});

  Future<void> getTrip() async {
    try {
      final trip = await repository.getTrip();

      if (trip != null) {
        emit(
          GenericCubitState.success(
            GetTripMainState(trip: trip),
          ),
        );
      } else {
        emit(
          GenericCubitState.success(
            EmptyTripMainState(),
          ),
        );
      }
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      if (statusCode == 404) {
        emit(
          GenericCubitState.success(
            EmptyTripMainState(),
          ),
        );
      } else {
        emit(
          GenericCubitState.failure(e.errorMessage),
        );
      }
    }
  }

  Future<void> getTempFormDetails() async {
    try {
      final tempForm = await repository.getTempFormDetails();
      logger.d('====tempForm $tempForm');
      if (tempForm?.status == TempFormStatus.NEW ||
          tempForm?.status == TempFormStatus.APPROVED ||
          tempForm?.status == TempFormStatus.REJECTED) {
        emit(
          GenericCubitState.success(
            GetTempFormDetailsMainState(tempForm: tempForm!),
          ),
        );
      } else {
        emit(
          GenericCubitState.success(
            EmptyTempFormMainState(),
          ),
        );
      }
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;

      if (statusCode == 404) {
        emit(
          GenericCubitState.success(
            EmptyTempFormMainState(),
          ),
        );
      } else {
        emit(
          GenericCubitState.failure(e.errorMessage),
        );
      }
    }
  }

  Future<void> getTempFormDetailsForFecthing() async {
    try {
      final tempForm = await repository.getTempFormDetails();
      if (tempForm?.status == TempFormStatus.NEW ||
          tempForm?.status == TempFormStatus.APPROVED ||
          tempForm?.status == TempFormStatus.REJECTED) {
        emit(
          GenericCubitState.success(
            GetTempFormDetailsMainState(tempForm: tempForm!),
          ),
        );
      } else {
        emit(
          GenericCubitState.success(
            EmptyTempFormMainState(),
          ),
        );
      }
    } on DioException catch (e) {
      logger.e(e.errorMessage);
    }
  }

  Future<void> getWarningList(int page) async {
    try {
      final warningList = await repository.getWarningList(page);
      logger.d('===== warningList ${warningList.length}');
      emit(
        GenericCubitState.success(
          GetWarningListMainState(warningList: warningList),
        ),
      );
    } on DioException catch (e) {
      emit(
        GenericCubitState.failure(e.errorMessage),
      );
    }
  }

  Future<void> getWarningListForFetching(int page) async {
    try {
      final warningList = await repository.getWarningList(page);
      emit(
        GenericCubitState.success(
          GetWarningListMainState(warningList: warningList),
        ),
      );
    } on DioException catch (e) {
      logger.e(e.errorMessage);
    }
  }

  Future<void> deleteNewTrip() async {
    emit(
      GenericCubitState.loading(),
    );
    try {
      await repository.cancelTempForm();
      emit(
        GenericCubitState.success(DidDeleteTripMainState()),
      );
    } on DioException catch (e) {
      emit(
        GenericCubitState.failure(e.errorMessage),
      );
    }
  }

  Future<void> closeNewTrip(String note) async {
    emit(
      GenericCubitState.loading(),
    );
    try {
      await repository.closeTempForm(note);
      emit(
        GenericCubitState.success(DidCloseTripMainState()),
      );
    } on DioException catch (e) {
      emit(
        GenericCubitState.failure(e.errorMessage),
      );
    }
  }

  void editNewTrip(String id) {
    emit(
      GenericCubitState.success(null),
    );
  }

  void reloadState() {
    emit(
      GenericCubitState.success(state.data),
    );
  }

  Future<void> submitArrived(CheckInRequest request) async {
    try {
      await repository.submitArrived(request);
      emit(
        GenericCubitState.success(
          EmptyTripMainState(),
        ),
      );
      getTrip();
    } on DioException catch (e) {
      emit(
        GenericCubitState.failure(e.errorMessage),
      );
    }
  }
}
