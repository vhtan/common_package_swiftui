import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mvvm_cubit/core/app_extension.dart';

class SecureStorageManager {
  final FlutterSecureStorage _secureStorage;

  SecureStorageManager(this._secureStorage);

  Future<String?> getToken() async {
    return _secureStorage.read(key: StoreKey.loginToken);
  }

  Future<String?> getRole() async {
    return _secureStorage.read(key: StoreKey.roleCode);
  }

  Future<void> saveToken(String token, String roleCode) async {
    await _secureStorage.write(
      key: StoreKey.loginToken,
      value: token,
    );
    await _secureStorage.write(
      key: StoreKey.roleCode,
      value: roleCode,
    );
  }

  Future<void> deleteAll() async {
    await _secureStorage.deleteAll();
  }
}
