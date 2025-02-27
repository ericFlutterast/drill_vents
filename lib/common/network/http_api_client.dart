import 'package:dio/dio.dart';
import 'package:drill_events/common/ports/http_client.dart';

final class HttpApiClient implements RestClient {
  const HttpApiClient(this._dio);

  final Dio _dio;

  @override
  Future<HttpResponse> get<T>(String path, {Map<String, dynamic>? queryParameters, Object? data}) async {
    final response = await _dio.get<T>(path, queryParameters: queryParameters, data: data);
    return HttpResponse(response.data, statusCode: response.statusCode, statusMessage: response.statusMessage);
  }

  @override
  Future<HttpResponse> post<T>(String path, {Object? data, Map<String, dynamic>? queryParameters}) async {
    final response = await _dio.post<T>(path, data: data, queryParameters: queryParameters);
    return HttpResponse(response.data, statusCode: response.statusCode, statusMessage: response.statusMessage);
  }
}
