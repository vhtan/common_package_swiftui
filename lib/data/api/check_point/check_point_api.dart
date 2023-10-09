import 'package:dio/dio.dart';
import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/common/network/api_helper.dart';
import 'package:mvvm_cubit/common/network/dio_client.dart';
import 'package:mvvm_cubit/core/api_config.dart';

class CheckPointApi with ApiHelper<dynamic> {
  final DioClient client;

  CheckPointApi({required this.client});

  Future<String?> uploadImage(String path) async {
    try {
      logger.e('uploadImage path= $path');
      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(path, filename: 'image.jpg'),
      });
      client.dio.options.headers['Content-Type'] = 'multipart/form-data';
      final apiResponse = await makePostRequest(
        client.dio.get(ApiConfig.uploadImage, data: formData),
      );
      return apiResponse.detail['imgUrl'];
    } on Error catch (e) {
      logger.e(e);
      return null;
    }
  }

  Future<dynamic> submitCheckPoint(String id) async {
    return await makePostRequest(
      client.dio.post(
        ApiConfig.arrivedStopPoint(id),
      ),
    );
  }
}
