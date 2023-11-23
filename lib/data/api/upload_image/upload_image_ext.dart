import 'package:dio/dio.dart';
import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/common/network/api_helper.dart';
import 'package:mvvm_cubit/common/network/dio_client.dart';
import 'package:mvvm_cubit/core/api_config.dart';

mixin UploadImageExt {
  Future<ImageResponse?> uploadImage(
      DioClient client, String path, ApiHelper<dynamic> apiHelper) async {
    try {
      logger.i('uploadImage path= $path');
      var formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(path, filename: 'image.jpg'),
      });
      final apiResponse = await apiHelper.makePostRequest(
        client.dio.post(ApiConfig.uploadImage, data: formData),
      );
      final imageUrl = apiResponse.detail['imgUrl'];
      final imageName = apiResponse.detail['imgName'];
      return ImageResponse(
        imageUrl: imageUrl,
        imageName: imageName,
      );
    } on Error catch (e) {
      logger.e(e);
      return null;
    }
  }
}

class ImageResponse {
  final String imageUrl;
  final String imageName;

  const ImageResponse({
    required this.imageUrl,
    required this.imageName,
  });
}
