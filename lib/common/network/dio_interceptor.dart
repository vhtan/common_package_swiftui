import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mvvm_cubit/core/api_config.dart';
import 'package:mvvm_cubit/core/app_extension.dart';

class DioInterceptor extends Interceptor {
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      printTime: false,
    ),
  );

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.addAll(ApiConfig.header);
    options.headers.removeWhere((key, value) => value == null);
    _logger.i('====================START====================');
    _logger.i('HTTP method => ${options.method} ');
    _logger.i(
        'Request => ${options.baseUrl}${options.path}${options.queryParameters.format}');
    _logger.i('Header  => ${options.headers}');
    final curlCommand = _generateCurlCommand(options);
    // _logger.i('cURL Request: $curlCommand');
    // print('cURL Request: $curlCommand');
    log('cURL Request: $curlCommand');
    return super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final options = err.requestOptions;
    _logger.e(
        'Error: ${err.error}. ${err.requestOptions.uri}. ${options.method}. Code: ${err.message}'); // Error log
    return super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logger.d('Response => StatusCode: ${response.statusCode}'); // Debug log
    _logger.d(
        'Response => ${response.requestOptions.uri} Body: ${response.data}'); // Debug log
    return super.onResponse(response, handler);
  }

  String _generateCurlCommand(RequestOptions options) {
    final method = options.method;
    final url = options.uri.toString();
    final headers = options.headers;

    final headerParams = headers.entries
        .map((entry) => '-H "${entry.key}: ${entry.value}" ')
        .join(' ');
    String data = '';
    try {
      Object? object = options.data as Object;
      data = ' --data \'${object.toJsonString()}\' ';
    } catch (e) {
      _logger.d("Failed to cast dynamicObject to Object: $e");
    }

    return 'curl -X $method $headerParams$data$url';
  }
}
