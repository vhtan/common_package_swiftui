import 'package:mvvm_cubit/common/repository/repository_helper.dart';
import 'package:mvvm_cubit/common/network/api_result.dart';
import 'package:mvvm_cubit/data/api/main/main_api.dart';
import 'package:mvvm_cubit/data/model/main/delivery.dart';

class MainRepository with RepositoryHelper<Delivery> {
  final MainApi mainApi;

  const MainRepository({required this.mainApi});

  Future<ApiResult<List<Delivery>>> getListDelivery() async {
    return checkItemsFailOrSuccess(mainApi.getListDelivery());
  }
}
