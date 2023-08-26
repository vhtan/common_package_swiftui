import 'package:mvvm_cubit/common/cubit/generic_cubit.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/data/model/main/delivery.dart';
import 'package:mvvm_cubit/data/request/auth/logout_request.dart';
import 'package:mvvm_cubit/repository/main/main_repository.dart';

class MainCubit extends GenericCubit<Delivery> {
  final MainRepository repository;

  MainCubit({required this.repository});

  Future<void> getListDelivery() async {
    getItems(repository.getListDelivery());
  }

  Future<void> logout(String username) async {
    emit(GenericCubitState.loading());
    final response =
        await repository.mainApi.logout(LogoutRequest(username: username));
    if (response != null) {
      print("logout response = $response");
      emit(GenericCubitState.success(null));
    } else {
      emit(GenericCubitState.failure("Error"));
    }
  }
}
