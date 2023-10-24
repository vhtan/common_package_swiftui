import 'package:mvvm_cubit/config/base_config.dart';

class ConfigStag extends BaseConfig {
  @override
  String get baseUrl => 'https://stage.acbtest.vn/stg/fund-transport';

  @override
  String get vacomUrl =>
      'https://cash-optimization-stg.acbtest.vn/route-tracking/car1?searchText=';
}
