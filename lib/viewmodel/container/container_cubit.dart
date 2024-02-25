import 'package:dio/dio.dart';
import 'package:material_text_fields/utils/extensions.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/common/network/api_error.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/data/api/sos/sos_submit_request.dart';
import 'package:mvvm_cubit/data/model/container/menu_type.dart';
import 'package:mvvm_cubit/data/model/notification/notification_response.dart';
import 'package:mvvm_cubit/data/request/push_token/push_token_request.dart';
import 'package:mvvm_cubit/repository/main/main_repository.dart';
import 'package:mvvm_cubit/repository/sos/sos_repository.dart';

class ContainerCubit extends GenericCubit<ContainerState> {
  final MainRepository repository;
  final SosRepository sosRepository;

  ContainerCubit({
    required this.repository,
    required this.sosRepository,
  });

  Future<void> updatePushToken(String token) async {
    repository.updatePushToken(
      PushTokenRequest(deviceToken: token),
    );
  }

  Future<void> totalUnreadNotification() async {
    emit(
      GenericCubitState.loading(),
    );
    try {
      final total = await repository.totalUnreadNotification();

      emit(
        GenericCubitState.success(
          TotalUnreadNotificationMainState(total: total),
        ),
      );
    } on DioException catch (e) {
      emit(
        GenericCubitState.failure(e.errorMessage),
      );
    }
  }

  void getEmergencyNotificationList() async {
    final response = await repository.getNotificationList(true);
    try {
      emit(
        GenericCubitState.success(
          EmergencyNotificationListSuccess(
            list: response.where((element) => element.read == false).toList(),
          ),
        ),
      );
    } on DioException catch (e) {
      logger.e(e.errorMessage);
    }
  }

  void readNotification(String id) async {
    await repository.readNotification(id);
    try {} on DioException catch (e) {
      emit(
        GenericCubitState.failure(e.errorMessage),
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

  Future<void> checkVehicleExisted(SOSType type) async {
    emit(
      GenericCubitState.loading(),
    );
    try {
      final tripDetails = await repository.getTrip();
      if (tripDetails?.vehicle?.id?.isNotNullOrEmpty() == true) {
        emit(
          GenericCubitState.success(
            ExistedVehicleContainerState(
              id: tripDetails?.vehicle?.id ?? '',
              type: type,
            ),
          ),
        );
        return;
      }

      final tempForm = await repository.getTempFormDetails();
      if (tempForm?.vehicle?.id?.isNotNullOrEmpty() == true) {
        emit(
          GenericCubitState.success(
            ExistedVehicleContainerState(
              id: tempForm?.vehicle?.id ?? '',
              type: type,
            ),
          ),
        );
        return;
      }
      emit(
        GenericCubitState.success(
          NotExistedVehicleContainerState(
            type: type,
          ),
        ),
      );
    } on DioException catch (e) {
      emit(
        GenericCubitState.failure(e.errorMessage),
      );
    }
  }

  void submitSOS(SOSSubmitRequest request) async {
    emit(
      GenericCubitState.loading(),
    );
    try {
      final apiResponse = await sosRepository.submitSOS(request);

      if (apiResponse.code == ErrorCode.SUCCESS) {
        emit(
          GenericCubitState.success(
            DidSubmitSOSSuccessContainerState(sosId: apiResponse.detail['id']),
          ),
        );
      } else {
        emit(
          GenericCubitState.failure(
              'Báo cáo sự cố thất bại. Vui lòng thử lại sau.'),
        );
      }
    } on DioException catch (e) {
      emit(
        GenericCubitState.failure(e.errorMessage),
      );
    }
  }
}

class ContainerState {}

class MenuContainerState extends ContainerState {
  MenuType menuType;
  MenuContainerState({required this.menuType});
}

class TotalUnreadNotificationMainState extends ContainerState {
  int total;
  TotalUnreadNotificationMainState({
    required this.total,
  });
}

class EmergencyNotificationListSuccess extends ContainerState {
  List<NotificationResponse> list;

  EmergencyNotificationListSuccess({required this.list});
}

class ExistedVehicleContainerState extends ContainerState {
  String id;
  SOSType type;

  ExistedVehicleContainerState({
    required this.id,
    required this.type,
  });
}

class NotExistedVehicleContainerState extends ContainerState {
  SOSType type;

  NotExistedVehicleContainerState({
    required this.type,
  });
}

class DidSubmitSOSSuccessContainerState extends ContainerState {
  String sosId;
  DidSubmitSOSSuccessContainerState({
    required this.sosId,
  });
}
