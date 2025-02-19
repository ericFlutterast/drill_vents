import 'package:dio/dio.dart';

part 'request_types.dart';

final class HttpApiClient {
  const HttpApiClient(this._dio);

  final Dio _dio;

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
