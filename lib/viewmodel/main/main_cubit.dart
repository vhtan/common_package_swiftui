import 'package:mvvm_cubit/common/cubit/generic_cubit.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/data/model/main/trip.dart';
import 'package:mvvm_cubit/data/request/auth/logout_request.dart';
import 'package:mvvm_cubit/repository/main/main_repository.dart';
import 'package:mvvm_cubit/viewmodel/main/main_state.dart';

class MainCubit extends GenericCubit<MainState> {
  final MainRepository repository;

  MainCubit({required this.repository});

  Future<void> getTrip() async {
    emit(GenericCubitState.success(null));

    // emit(GenericCubitState.success(
    //     MainState(pendingTrip: Trip(title: '', duties: []))));

    // emit(GenericCubitState.success(
    //     MainState(trip: Trip(title: '', duties: []))));
  }

  void addNewTrip(Trip trip) {
    emit(GenericCubitState.success(MainState(pendingTrip: trip, trip: null)));
  }

  void deleteNewTrip() {
    emit(GenericCubitState.success(MainState(pendingTrip: null, trip: null)));
  }

  void editNewTrip() {
    emit(GenericCubitState.success(MainState(pendingTrip: null, trip: null)));
  }

  Future<void> logout() async {
    emit(GenericCubitState.loading());
    final response =
        await repository.mainApi.logout(const LogoutRequest(username: 'acb'));
    if (response != null) {
      print("logout response = $response");
      emit(GenericCubitState.success(null));
    } else {
      emit(GenericCubitState.failure("Error"));
    }
  }
}
