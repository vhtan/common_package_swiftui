import 'package:mvvm_cubit/common/repository/repository_helper.dart';
import 'package:mvvm_cubit/data/api/main/main_api.dart';
import 'package:mvvm_cubit/data/model/main/trip.dart';
import 'package:mvvm_cubit/data/model/main/trip/trip_response.dart';
import 'package:mvvm_cubit/data/model/temp_form/temp_form_response.dart';

class MainRepository with RepositoryHelper<Trip> {
  final MainApi _api;

  const MainRepository({required MainApi api}) : _api = api;

  Future<TripResponse> getTrip() async {
    return _api.getTrip();
  }

  Future<TempFormResponse> getTempFormDetails() async {
    return _api.getTempFormDetails();
  }
}
