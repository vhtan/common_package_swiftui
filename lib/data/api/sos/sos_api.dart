import 'package:mvvm_cubit/common/network/api_helper.dart';
import 'package:mvvm_cubit/common/network/dio_client.dart';
import 'package:mvvm_cubit/core/api_config.dart';
import 'package:mvvm_cubit/data/api/upload_image/upload_image_ext.dart';

class SosApi extends ApiHelper<dynamic> with UploadImageExt {
  final DioClient client;

  SosApi({required this.client});

  Future<dynamic> submitSos(String id) async {
    return await makePostRequest(
      client.dio.post(
        ApiConfig.arrivedStopPoint(id),
      ),
    );
  }
}
