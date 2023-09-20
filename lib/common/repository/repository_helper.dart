import 'package:dio/dio.dart' show DioException;
import 'package:mvvm_cubit/common/network/api_result.dart';
import 'package:mvvm_cubit/common/network/dio_exception.dart';

mixin RepositoryHelper<T> {
  Future<ApiResult<List<T>>> checkItemsFailOrSuccess(
    Future<List<T>> apiCallback,
  ) async {
    try {
      final List<T> items = await apiCallback;
      return ApiResult.success(items);
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      return ApiResult.failure(errorMessage);
    }
  }

  Future<ApiResult<T>> checkItemFailOrSuccess(
    Future<T> apiCallback,
  ) async {
    try {
      final T item = await apiCallback;
      return ApiResult<T>.success(item);
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      return ApiResult.failure(errorMessage);
    }
  }
}
