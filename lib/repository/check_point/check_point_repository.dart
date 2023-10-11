import 'package:mvvm_cubit/common/repository/repository_helper.dart';
import 'package:mvvm_cubit/data/api/check_point/check_point_api.dart';

class CheckPointRepository with RepositoryHelper<dynamic> {
  final CheckPointApi api;

  const CheckPointRepository({required this.api});

  Future<dynamic> uploadImage(String path) async {
    return await api.uploadImage(api.client, path, api);
  }
}
