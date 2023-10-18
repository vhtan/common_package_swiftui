import 'package:mvvm_cubit/common/repository/repository_helper.dart';
import 'package:mvvm_cubit/data/api/sos/sos_api.dart';
import 'package:mvvm_cubit/data/api/sos/sos_submit_request.dart';

class SosRepository with RepositoryHelper<dynamic> {
  final SosApi _api;

  const SosRepository({required SosApi api}) : _api = api;

  Future<dynamic> uploadImage(String path) async {
    return _api.uploadImage(
      _api.client,
      path,
      _api,
    );
  }

  Future<dynamic> getReasons() async {
    return _api.getReasons();
  }

  Future<dynamic> submitSOS(SOSSubmitRequest request) async {
    return _api.submitSos(request);
  }
}
