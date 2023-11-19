import 'package:dio/dio.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/data/model/container/menu_type.dart';
import 'package:mvvm_cubit/data/model/notification/notification_response.dart';
import 'package:mvvm_cubit/data/request/push_token/push_token_request.dart';
import 'package:mvvm_cubit/repository/main/main_repository.dart';

class ContainerCubit extends GenericCubit<ContainerState> {
  final MainRepository repository;

  ContainerCubit({required this.repository});

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
        GenericCubitState.failure(e.message ?? 'Error'),
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
    } catch (ex) {
      emit(
        GenericCubitState.failure(ex.toString()),
      );
    }
  }

  void readNotification(String id) async {
    await repository.readNotification(id);
    try {} catch (ex) {
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
