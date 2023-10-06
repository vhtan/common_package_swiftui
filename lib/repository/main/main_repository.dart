import 'package:mvvm_cubit/common/repository/repository_helper.dart';
import 'package:mvvm_cubit/common/network/api_result.dart';
import 'package:mvvm_cubit/data/api/main/main_api.dart';
import 'package:mvvm_cubit/data/model/main/trip.dart';

class MainRepository with RepositoryHelper<Trip> {
  final MainApi api;

  const MainRepository({required this.api});

  Future<ApiResult<Trip>> getTrip() async {
    return checkItemFailOrSuccess(api.getTrip());
  }
}
