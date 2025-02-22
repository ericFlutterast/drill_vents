class HttpResponse<T> {
  HttpResponse(this.data, {this.statusCode, this.statusMessage});

  final T? data;
  final int? statusCode;
  final String? statusMessage;
}

abstract interface class RestClient {
  Future<HttpResponse> get<T>(String path, {Map<String, dynamic>? queryParameters});
  Future<HttpResponse> post<T>(String path, {Object? data, Map<String, dynamic>? queryParameters});
}
