import 'package:mvvm_cubit/common/repository/repository_helper.dart';
import 'package:mvvm_cubit/data/api/sos/sos_api.dart';

class SosRepository with RepositoryHelper<dynamic> {
  final SosApi api;

  const SosRepository({required this.api});

  Future<dynamic> uploadImage(String path) async {
    return api.uploadImage(api.client, path, api);
  }
}
