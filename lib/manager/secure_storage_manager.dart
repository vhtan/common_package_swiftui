import 'package:hive_flutter/hive_flutter.dart';
import 'package:mvvm_cubit/core/app_extension.dart';

class SecureStorageManager {
  Future<String?> getToken() async {
    var box = await Hive.openBox(StoreKey.loginToken);
    return await box.get(StoreKey.loginToken);
  }

  Future<String?> getRole() async {
    var box = await Hive.openBox(StoreKey.roleCode);
    return await box.get(StoreKey.roleCode);
  }

  Future<void> saveToken(String token, String roleCode) async {
    var tokenBox = await Hive.openBox(StoreKey.loginToken);
    await tokenBox.put(StoreKey.loginToken, token);

    var roleCodeBox = await Hive.openBox(StoreKey.roleCode);
    await roleCodeBox.put(StoreKey.roleCode, roleCode);
  }

  Future<void> deleteAll() async {
    var tokenBox = await Hive.openBox(StoreKey.loginToken);
    var roleCodeBox = await Hive.openBox(StoreKey.roleCode);
    await tokenBox.clear();
    await roleCodeBox.clear();
  }
}
