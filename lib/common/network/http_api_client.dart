import 'package:dio/dio.dart';
import 'package:drill_events/common/ports/http_client.dart';

final class HttpApiClient {
  const HttpApiClient(this._dio);

  final Dio _dio;

  Future<HttpResponse> get<T>(String path, {Map<String, dynamic>? queryParameters, Options? options}) async {
    final response = await _dio.get<T>(path, queryParameters: queryParameters, options: options);
    return HttpResponse(response.data, statusCode: response.statusCode, statusMessage: response.statusMessage);
  }

  Future<HttpResponse> post<T>(String path, {Object? data, Map<String, dynamic>? queryParameters}) async {
    final response = await _dio.post<T>(path, data: data, queryParameters: queryParameters);
    return HttpResponse(response.data, statusCode: response.statusCode, statusMessage: response.statusMessage);
  }

  Future<HttpResponse> patch<T>(String path, {Object? data}) async {
    final response = await _dio.patch<T>(path, data: data);
    return HttpResponse(response.data, statusCode: response.statusCode, statusMessage: response.statusMessage);
  }

  Future<HttpResponse> delete<T>(String path) async {
    final response = await _dio.delete<T>(path);
    return HttpResponse(response.data, statusCode: response.statusCode, statusMessage: response.statusMessage);
  }
}
