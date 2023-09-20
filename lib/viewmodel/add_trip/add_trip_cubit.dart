import 'package:mvvm_cubit/common/cubit/generic_cubit.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/data/model/main/trip.dart';
import 'package:mvvm_cubit/repository/add_trip/add_trip_repository.dart';

class AddTripCubit extends GenericCubit<Trip> {
  final AddTripRepository repository;

  AddTripCubit({required this.repository});

  Future<void> createTrip() async {
    emit(GenericCubitState.success(Trip(title: '', duties: [])));
  }
}
