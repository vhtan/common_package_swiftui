import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/data/model/container/menu_type.dart';
import 'package:mvvm_cubit/data/request/auth/logout_request.dart';
import 'package:mvvm_cubit/repository/main/main_repository.dart';

class ContainerCubit extends Cubit<GenericCubitState<MenuType>> {
  final MainRepository repository;
  ContainerCubit({required this.repository})
      : super(GenericCubitState.loading());

  Future<void> menuAction(MenuType menuType) async {
    emit(GenericCubitState.success(menuType));
    switch (menuType) {
      case MenuType.logOut:
        logOut();
      default:
        break;
    }
  }

  Future<void> logOut() async {
    emit(GenericCubitState.success(MenuType.logOut));
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
