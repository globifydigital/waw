// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptor extends Interceptor {
  const LoggingInterceptor({
    this.log = false,
    this.logRequestHeader = true,
    this.logRequestBody = true,
    this.logResponseHeader = true,
    this.logResponseBody = true,
  });

  final bool log;
  final bool logRequestHeader;
  final bool logRequestBody;
  final bool logResponseHeader;
  final bool logResponseBody;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode && log) {
      print("~~onRequest.uri:${options.method} ${options.uri.toString()}");
      if (logRequestHeader) {
        print("~~onRequest.headers: ${options.headers.toString()}");
      }
      if (logRequestBody) {
        print("~~onRequest.body: ${options.data}");
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode && log) {
      print(
        "~~onResponse.uri:${response.requestOptions.method} ${response.requestOptions.uri.toString()} - ${response.statusCode} | ${response.statusMessage}",
      );

      if (logResponseHeader) {
        print("~~onResponse.headers: ${response.headers.toString()}");
      }
      if (logResponseBody) {
        print("~~onResponse.data: ${response.data}");
      }
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (kDebugMode && log) {
      print(
        "~~onError.uri:${err.requestOptions.method} ${err.requestOptions.uri.toString()}",
      );
      print("~~onError.type: ${err.type}");
      print("~~onError.stackTrace: ${err.stackTrace}");
      print("~~onError.message: ${err.message}");
      print("~~onError.response: ${err.response?.toString()}");
    }
    handler.next(err);
  }
}
