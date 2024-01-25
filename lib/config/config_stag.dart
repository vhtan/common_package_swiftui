import 'package:mvvm_cubit/config/base_config.dart';

class ConfigStag extends BaseConfig {
  @override
  // String get baseUrl => 'https://stage.acbtest.vn/stg/fund-transport'; // UAT

  String get baseUrl => 'https://apiapp-pat.acbtest.vn/vietmap-api-app'; // PAT

  @override
  // String get vacomUrl =>
  //     'https://cash-optimization-stg.acbtest.vn/route-tracking/car1?searchText=';

  String get vacomUrl =>
      'https://quanlydieuquypat.acbtest.vn/route-tracking/car1?pyc=';
}
