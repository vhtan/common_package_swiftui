import 'package:hive/hive.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/data/model/auth/login_response.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';

class HiveStorageManager {
  const HiveStorageManager();

  Future<void> initHive() async {
    final path = await _getDocumentsDirectory();
    Hive.init(path);
    _registerAdapters();
  }

  void _registerAdapters() {
    Hive.registerAdapter(_LoginResponseHiveAdapter());
    Hive.registerAdapter(_RoleResponseHiveAdapter());
  }

  Future<String> _getDocumentsDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<void> saveLoginData(LoginResponse loginData) async {
    var box = await Hive.openBox(StoreKey.userData);
    await box.put(StoreKey.userData, loginData);
  }

  Future<LoginResponse?> getLoginData() async {
    var box = await Hive.openBox(StoreKey.userData);
    final data = await box.get(StoreKey.userData);
    final userData = data as LoginResponse?;
    return userData;
  }
}

class _LoginResponseHiveAdapter extends TypeAdapter<LoginResponse> {
  @override
  LoginResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LoginResponse(
      session: fields[0] as String?,
      name: fields[1] as String?,
      email: fields[2] as String?,
      role: fields[3] as RoleResponse?,
      arrivalLimitRadius: fields[4] as double?,
      code: fields[5] as String?,
      manager: fields[6] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, LoginResponse obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.session)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.role)
      ..writeByte(4)
      ..write(obj.arrivalLimitRadius)
      ..writeByte(5)
      ..write(obj.code)
      ..writeByte(6)
      ..write(obj.manager);
  }

  @override
  int get typeId => 0;
}

class _RoleResponseHiveAdapter extends TypeAdapter<RoleResponse> {
  @override
  RoleResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RoleResponse(
      name: fields[0] as String?,
      code: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RoleResponse obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.code);
  }

  @override
  int get typeId => 1;
}
