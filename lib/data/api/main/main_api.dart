import 'package:mvvm_cubit/common/network/api_helper.dart';
import 'package:mvvm_cubit/common/network/dio_client.dart';
import 'package:mvvm_cubit/core/api_config.dart';
import 'package:mvvm_cubit/data/model/main/trip.dart';

class MainApi with ApiHelper<Trip> {
  final DioClient client;

  MainApi({required this.client});

  Future<dynamic> getTrip() async {
    return await get(
      client.dio.get(
        ApiConfig.getTrip,
      ),
    );
  }

  Future<dynamic> getCurrencyList() async {
    return await get(
      client.dio.get(
        ApiConfig.currencyList,
      ),
    );
  }
}
