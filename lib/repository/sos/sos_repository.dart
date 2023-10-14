import 'package:mvvm_cubit/common/repository/repository_helper.dart';
import 'package:mvvm_cubit/data/api/sos/sos_api.dart';
import 'package:mvvm_cubit/data/api/sos/sos_submit_request.dart';

class SosRepository with RepositoryHelper<dynamic> {
  final SosApi api;

  const SosRepository({required this.api});

  Future<dynamic> uploadImage(String path) async {
    return api.uploadImage(api.client, path, api);
  }

  Future<dynamic> getReasons() async {
    return api.getReasons();
  }

  Future<dynamic> submitSOS(SOSSubmitRequest request) async {
    return api.submitSos(request);
  }
}
