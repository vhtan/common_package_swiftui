import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/data/model/container/container_view_status.dart';
import 'package:mvvm_cubit/data/request/auth/logout_request.dart';
import 'package:mvvm_cubit/repository/main/main_repository.dart';

class ContainerCubit extends Cubit<GenericCubitState<ContainerViewStatus>> {
  final MainRepository repository;
  ContainerCubit({required this.repository})
      : super(GenericCubitState.loading());

  void showRoute() {
    emit(GenericCubitState.success(ContainerViewStatus.route));
  }

  void showAccount() {
    emit(GenericCubitState.success(ContainerViewStatus.account));
  }

  Future<void> logOut() async {
    emit(GenericCubitState.success(ContainerViewStatus.logout));
    final response = await repository.mainApi
        .logout(const LogoutRequest(username: 'username'));
    if (response != null) {
      print("logout response = $response");
      // emit(GenericCubitState.success(null));
    } else {
      // emit(GenericCubitState.failure("Error"));
    }
  }
}
