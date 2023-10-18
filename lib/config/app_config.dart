import 'package:mvvm_cubit/config/config_dev.dart';
import 'package:mvvm_cubit/config/config_prod.dart';
import 'package:mvvm_cubit/config/config_stag.dart';

class AppConfig {
  static const environment = String.fromEnvironment(
    'FLAVOR',
    defaultValue: 'dev',
  );

  static String get apiBaseUrl {
    var baseUrl = '';
    if (environment == 'dev') baseUrl = ConfigDev.apiBaseUrl;
    if (environment == 'stag') baseUrl = ConfigStag.apiBaseUrl;
    if (environment == 'prod') baseUrl = ConfigProd.apiBaseUrl;
    baseUrl = '$baseUrl/app/api/v1';
    return baseUrl;
  }
}
