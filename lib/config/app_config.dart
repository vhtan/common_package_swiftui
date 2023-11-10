import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/config/base_config.dart';
import 'package:mvvm_cubit/config/config_dev.dart';
import 'package:mvvm_cubit/config/config_prod.dart';
import 'package:mvvm_cubit/config/config_stag.dart';

// ignore: constant_identifier_names
enum Env { DEV, PROD, STAG }

final Environment environment = Environment.instance;

class Environment {
  static const String prefix = '/app/api/v1';
  static final Environment _instance = Environment();
  static Environment get instance => _instance;
  BaseConfig config = ConfigDev();
  Env environmentConfig = Env.DEV;

  // run: flutter run -t lib/main.dart --dart-define=env=stg
  // build: flutter build -t lib/main.dart --dart-define=env=stg
  // flutter build apk --dart-define=env=stg
  Future<void> initConfig() async {
    const environmentParam = String.fromEnvironment('env', defaultValue: 'dev');
    switch (environmentParam) {
      case 'stg':
        environmentConfig = Env.STAG;
        break;
      case 'prod':
        environmentConfig = Env.PROD;
        break;
      default:
        environmentConfig = Env.DEV;
        break;
    }
    config = _getConfig(environmentConfig);
    logger.d('Environments: ${config.baseUrl}');
  }

  String fullUrl() => config.baseUrl + prefix;

  BaseConfig _getConfig(Env environment) {
    switch (environment) {
      case Env.PROD:
        return ConfigProd();
      case Env.STAG:
        return ConfigStag();
      default:
        return ConfigDev();
    }
  }

  String vacomUrl() => config.vacomUrl;
}
