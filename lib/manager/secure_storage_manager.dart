import 'package:hive_flutter/hive_flutter.dart';
import 'package:mvvm_cubit/core/app_extension.dart';

class SecureStorageManager {
  Future<String?> getToken() async {
    var box = await Hive.openBox(StoreKey.loginToken);
    return await box.get(StoreKey.loginToken);
  }

  // Future<bool> isManager() async {
  //   try {
  //     var box = await Hive.openBox(StoreKey.isManager);
  //     return await box.get(StoreKey.isManager);
  //   } catch (e) {
  //     return false;
  //   }
  // }

  Future<void> saveToken(String token) async {
    var tokenBox = await Hive.openBox(StoreKey.loginToken);
    await tokenBox.put(StoreKey.loginToken, token);

    // var isManagerBox = await Hive.openBox(StoreKey.isManager);
    // await isManagerBox.put(StoreKey.isManager, isManager);
  }

  Future<void> deleteAll() async {
    var tokenBox = await Hive.openBox(StoreKey.loginToken);
    // var isManagerBox = await Hive.openBox(StoreKey.isManager);
    await tokenBox.clear();
    // await isManagerBox.clear();
  }
}
