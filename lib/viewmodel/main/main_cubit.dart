import 'package:dio/dio.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/data/model/notification/notification_response.dart';
import 'package:mvvm_cubit/data/model/temp_form/temp_form_response.dart';
import 'package:mvvm_cubit/data/request/check_in/check_in_request.dart';
import 'package:mvvm_cubit/repository/main/main_repository.dart';
import 'package:mvvm_cubit/viewmodel/main/main_state.dart';

class MainCubit extends GenericCubit<MainState> {
  final MainRepository repository;

  MainCubit({required this.repository});

  Future<void> getTrip() async {
    emit(
      GenericCubitState.loading(),
    );
    try {
      final trip = await repository.getTrip();
      emit(
        GenericCubitState.success(
          GetTripMainState(trip: trip),
        ),
      );
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      if (statusCode == 404) {
        emit(
          GenericCubitState.success(
            EmptyTripMainState(),
          ),
        );
      } else {
        logger.d('statusCode else main = $statusCode');
        emit(
          GenericCubitState.failure(e.message ?? 'Error'),
        );
      }
    }
  }

  Future<void> getTempFormDetails() async {
    emit(
      GenericCubitState.loading(),
    );
    try {
      final tempForm = await repository.getTempFormDetails();
      if (tempForm.status == TempFormStatus.NEW ||
          tempForm.status == TempFormStatus.APPROVED) {
        emit(
          GenericCubitState.success(
            GetTempFormDetailsMainState(tempForm: tempForm),
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
          GenericCubitState.failure(e.message ?? 'Error'),
        );
      }
    }
  }

  Future<void> getWarningList() async {
    emit(
      GenericCubitState.loading(),
    );
    try {
      final warningList = await repository.getWarningList();
      emit(
        GenericCubitState.success(
          GetWarningListMainState(warningList: warningList),
        ),
      );
    } on DioException catch (e) {
      emit(
        GenericCubitState.failure(e.message ?? 'Error'),
      );
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
        GenericCubitState.failure(e.message ?? 'Error'),
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
        GenericCubitState.failure(e.message ?? 'Error'),
      );
    }
  }

  Future<void> totalUnreadNotificationTrip() async {
    emit(
      GenericCubitState.loading(),
    );
    try {
      await repository.totalUnreadNotification();
    } on DioException catch (e) {
      emit(
        GenericCubitState.failure(e.message ?? 'Error'),
      );
    }
  }

  void editNewTrip(String id) {
    emit(
      GenericCubitState.success(null),
    );
  }

  void reloadState() {
    logger.d('reloadState');
    emit(
      GenericCubitState.success(state.data),
    );
  }

  Future<void> submitArrived(CheckInRequest request) async {
    try {
      logger.d('didCaptureAndUploadImage $request');
      await repository.submitArrived(request);
      emit(
        GenericCubitState.success(
          EmptyTripMainState(),
        ),
      );
      getTrip();
    } on DioException catch (e) {
      logger.e(e.message);
      emit(
        GenericCubitState.failure(e.message ?? 'Error'),
      );
    }
  }

  void getEmergencyNotificationList() async {
    final response = await repository.getNotificationList(true);
    logger.d('getEmergencyNotificationList $response');
    try {
      emit(
        GenericCubitState.success(
          EmergencyNotificationListSuccess(
            list: response,
          ),
        ),
      );
    } catch (ex) {
      emit(
        GenericCubitState.failure(ex.toString()),
      );
    }
  }

  void updateEmergencyNotificationList(List<NotificationResponse> list) {
    emit(
      GenericCubitState.success(
        EmergencyNotificationListSuccess(
          list: list,
        ),
      ),
    );
  }

  void readNotification(String id) async {
    await repository.readNotification(id);
    try {} catch (ex) {
      emit(
        GenericCubitState.failure(ex.toString()),
      );
    }
  }
}
