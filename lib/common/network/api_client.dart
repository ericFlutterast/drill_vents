import 'package:dio/dio.dart';

part 'request_types.dart';

final class ApiClient {
  //const ApiClient(this._dio);

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://drillevents.drillcorp.ru:8333',
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    ),
  );

  Future<Response<T>> request<T>(RequestType type) async {
    return switch (type) {
      _Get() => await _dio.get<T>(
        type.path,
        data: type.data,
        queryParameters: type.queryParameters,
        options: type.options,
        cancelToken: type.cancelToken,
        onReceiveProgress: type.onReceiveProgress,
      ),
      _Post() => _dio.post<T>(
        type.path,
        data: type.data,
        queryParameters: type.queryParameters,
        options: type.options,
        cancelToken: type.cancelToken,
        onReceiveProgress: type.onReceiveProgress,
        onSendProgress: type.onSendProgress,
      ),
      _Delete() => _dio.delete<T>(
        type.path,
        data: type.data,
        queryParameters: type.queryParameters,
        options: type.options,
        cancelToken: type.cancelToken,
      ),
      _Patch() => _dio.patch<T>(
        type.path,
        data: type.data,
        queryParameters: type.queryParameters,
        options: type.options,
        cancelToken: type.cancelToken,
        onReceiveProgress: type.onReceiveProgress,
        onSendProgress: type.onSendProgress,
      ),
      _Put() => _dio.put<T>(
        type.path,
        data: type.data,
        queryParameters: type.queryParameters,
        options: type.options,
        cancelToken: type.cancelToken,
        onReceiveProgress: type.onReceiveProgress,
        onSendProgress: type.onSendProgress,
      ),
    };
  }
}
