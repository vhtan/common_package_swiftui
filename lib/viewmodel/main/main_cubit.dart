import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/data/request/check_in/check_in_request.dart';
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
      if (state.data == null) {
        emit(
          GenericCubitState.success(
            MainState(
              id: '',
              trip: trip,
            ),
          ),
        );
      } else {
        emit(
          GenericCubitState.success(
            state.data?.copyWith(
              trip: trip,
            ),
          ),
        );
      }
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      if (statusCode == 404) {
        if (state.data == null) {
          emit(
            GenericCubitState.success(
              MainState(
                id: '',
                trip: null,
              ),
            ),
          );
        } else {
          emit(
            GenericCubitState.success(
              state.data?.copyWith(
                trip: null,
              ),
            ),
          );
        }
      } else {
        emit(
          GenericCubitState.failure(e.message ?? 'Error'),
        );
      }
    }
  }

  Future<void> getTempFormDetails() async {
    try {
      emit(
        GenericCubitState.loading(),
      );
      final tempForm = await repository.getTempFormDetails();
      if (state.data == null) {
        emit(
          GenericCubitState.success(
            MainState(
              id: '',
              tempForm: tempForm,
            ),
          ),
        );
      } else {
        emit(
          GenericCubitState.success(
            state.data?.copyWith(
              tempForm: tempForm,
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

  Future<void> getWarningList() async {
    try {
      emit(
        GenericCubitState.loading(),
      );
      final warningList = await repository.getWarningList();
      if (state.data == null) {
        emit(
          GenericCubitState.success(
            MainState(
              id: '',
              warningList: warningList,
            ),
          ),
        );
      } else {
        emit(
          GenericCubitState.success(
            state.data?.copyWith(
              warningList: warningList,
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

  Future<void> deleteNewTrip() async {
    emit(
      GenericCubitState.loading(),
    );
    try {
      await repository.cancelTempForm();
      emit(
        GenericCubitState.success(
          state.data?.copyWith(
            tempForm: null,
          ),
        ),
      );
    } on DioException catch (e) {
      emit(
        GenericCubitState.failure(e.message ?? 'Error'),
      );
    }
  }

  void editNewTrip(String id) {
    emit(
      GenericCubitState.success(
        MainState(
          id: id,
          tempForm: null,
          trip: null,
        ),
      ),
    );
  }

  void reloadState() {
    logger.d('reloadState');
    emit(
      GenericCubitState.success(state.data),
    );
  }

  void startCheckIn(String id, LocationData current, LocationData destination) {
    logger.d('distance ${calculateDistance(current, destination)}');
    if (calculateDistance(current, destination) > 20) {
      emit(
        GenericCubitState.success(
          state.data?.copyWith(
            id: id,
            canCheckIn: true,
            locationData: current,
          ),
        ),
      );
    } else {
      emit(
        GenericCubitState.success(
          state.data?.copyWith(
            id: id,
            canCheckIn: false,
            locationData: current,
          ),
        ),
      );
    }
  }

  double calculateDistance(LocationData start, LocationData end) {
    double distance = Geolocator.distanceBetween(
      start.latitude ?? 0,
      start.longitude ?? 0,
      end.latitude ?? 0,
      end.longitude ?? 0,
    );
    return distance;
  }

  Future<void> didCaptureAndUploadImage(String path) async {
    try {
      final data = state.data;
      logger.d('didCaptureAndUploadImage $data');
      if (data != null) {
        logger.d('didCaptureAndUploadImage data != null');
        final response = await repository.submitArrived(
          CheckInRequest(
            id: data.id!,
            imagePath: path,
            latitude: data.locationData!.latitude!,
            longitude: data.locationData!.longitude!,
          ),
        );
        getTrip();
      }
    } on DioException catch (e) {
      logger.e(e.message);
      emit(
        GenericCubitState.failure(e.message ?? 'Error'),
      );
    }
  }
}
