import 'package:mvvm_cubit/config/base_config.dart';

class ConfigProd extends BaseConfig {
  @override
  String get baseUrl => 'https://fundtransport-app.acb.vn/vietmap-api-app';

  @override
  String get vacomUrl =>
      'https://quanlydieuquy.acb.com.vn/route-tracking/car1?pyc=';
}
