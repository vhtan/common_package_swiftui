// ignore_for_file: non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/common/network/api_helper.dart';
import 'package:mvvm_cubit/common/network/dio_client.dart';
import 'package:mvvm_cubit/core/api_config.dart';

mixin UploadImageExt {
  Future<String?> uploadImage(
      DioClient client, String path, ApiHelper<dynamic> apiHelper) async {
    try {
      logger.e('uploadImage path= $path');
      var formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(path, filename: 'image'),
      });
      final apiResponse = await apiHelper.makePostRequest(
        client.dio.post(ApiConfig.uploadImage, data: formData),
      );
      return apiResponse.detail['imgUrl'];
    } on Error catch (e) {
      logger.e(e);
      return null;
    }
  }
}
