import 'package:mvvm_cubit/common/network/api_helper.dart';
import 'package:mvvm_cubit/common/network/api_response/api_response.dart';
import 'package:mvvm_cubit/common/network/dio_client.dart';
import 'package:mvvm_cubit/core/api_config.dart';
import 'package:mvvm_cubit/data/api/sos/sos_submit_request.dart';
import 'package:mvvm_cubit/data/api/upload_image/upload_image_ext.dart';

class SosApi extends ApiHelper<dynamic> with UploadImageExt {
  final DioClient client;

  SosApi({required this.client});

  Future<ApiResponse> submitSos(SOSSubmitRequest request) async {
    return await makePostRequest(
      client.dio.post(ApiConfig.submitSOS, data: request.toParams()),
    );
  }

  Future<ApiResponse> warningSOS(SOSRobberSubmitRequest request) async {
    return await makePostRequest(
      client.dio.post(ApiConfig.warningSOS, data: request.toParams()),
    );
  }

  Future<dynamic> getReasons() async {
    return await makeGetRequest(client.dio.get(ApiConfig.getSOSReasons));
  }
}
