import 'package:dio/dio.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/logger/logger.dart';
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
      emit(
        GenericCubitState.success(
          GetTempFormDetailsMainState(tempForm: tempForm),
        ),
      );
    } on DioException catch (e) {
      emit(
        GenericCubitState.failure(e.message ?? 'Error'),
      );
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

  // Future<void> didCaptureAndUploadImage(String path) async {
  //   try {
  //     final data = state.data;
  //     logger.d('didCaptureAndUploadImage $data');
  //     if (data != null) {
  //       logger.d('didCaptureAndUploadImage data != null');
  //       final response = await repository.submitArrived(
  //         CheckInRequest(
  //           id: data.id!,
  //           imagePath: path,
  //           latitude: data.locationData!.latitude!,
  //           longitude: data.locationData!.longitude!,
  //         ),
  //       );
  //       getTrip();
  //     }
  //   } on DioException catch (e) {
  //     logger.e(e.message);
  //     emit(
  //       GenericCubitState.failure(e.message ?? 'Error'),
  //     );
  //   }
  // }
}
