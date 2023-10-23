import 'package:mvvm_cubit/config/base_config.dart';

class ConfigProd extends BaseConfig {
  @override
  String get baseUrl => 'https://quanlydieuquy.acb.com.vn';

  @override
  String get vacomUrl =>
      'https://quanlydieuquy.acb.com.vn/route-tracking/car1?searchText=';
}
