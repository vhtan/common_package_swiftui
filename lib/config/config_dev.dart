import 'package:mvvm_cubit/config/base_config.dart';

class ConfigDev extends BaseConfig {
  @override
  String get baseUrl => 'http://45.119.81.161:32181';

  @override
  String get vacomUrl =>
      'https://cash-optimization-stg.acbtest.vn/route-tracking/car1?searchText=';
}
