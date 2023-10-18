import 'package:mvvm_cubit/common/repository/repository_helper.dart';
import 'package:mvvm_cubit/data/api/check_point/check_point_api.dart';

class CheckPointRepository with RepositoryHelper<dynamic> {
  final CheckPointApi _api;

  const CheckPointRepository({required CheckPointApi api}) : _api = api;

  Future<String?> uploadImage(String path) async {
    return await _api.uploadImage(
      _api.client,
      path,
      _api,
    );
  }
}
