import 'package:mvvm_cubit/common/repository/repository_helper.dart';
import 'package:mvvm_cubit/data/api/add_trip/add_trip.dart';
import 'package:mvvm_cubit/data/model/main/trip.dart';
import 'package:mvvm_cubit/data/request/add_trip/add_trip_request.dart';

class AddTripRepository with RepositoryHelper<Trip> {
  final AddTripApi api;

  const AddTripRepository({required this.api});

  Future<dynamic> getListDelivery(AddTripRequest request) async {
    return api.createTrip(request);
  }
}
