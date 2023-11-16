import 'package:dio/dio.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/data/model/container/menu_type.dart';
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
          TotalUnreadNotificationMainState(total: 12),
        ),
      );
    } on DioException catch (e) {
      emit(
        GenericCubitState.failure(e.message ?? 'Error'),
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
