import 'package:mvvm_cubit/common/network/api_helper.dart';
import 'package:mvvm_cubit/common/network/dio_client.dart';
import 'package:mvvm_cubit/data/model/main/delivery.dart';
import 'package:mvvm_cubit/core/api_config.dart';

class MainApi with ApiHelper<Delivery> {
  final DioClient dioClient;

  MainApi({required this.dioClient});

  Future<List<Delivery>> getListDelivery() async {
    Map<String, String> queryParameters = <String, String>{};

    // if (gender != null && gender != Gender.all) {
    //   queryParameters.addAll({'gender': gender.name});
    // }

    // if (status != null && status != DeliveryStatus.all) {
    //   queryParameters.addAll({'status': status.name});
    // }

    return await makeGetRequest(
        dioClient.dio
            .get(ApiConfig.listDelivery, queryParameters: queryParameters),
        Delivery.fromJson);
  }
}
