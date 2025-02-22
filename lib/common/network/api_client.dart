import 'package:dio/dio.dart';

part 'request_types.dart';

// TODO: потом поубирай комменты
final class HttpApiClient {
  const HttpApiClient(this._dio);

  final Dio _dio;

  // TODO: Может лучше сделать под каждый тип свой метод? типо client.get() - работает быстрее так как нет перебора в свиче каждый раз. Смотри пример в rest_api_client.dart
  // в параметры прокидывать список тогда отпадет необходимость использовать все классы. И нет смысла передавать все параметры для дио, когда понадобятся тогда лучше добавить
  // То что тут возвращается response из пакета dio на самом деле убивает всю концепцию этого класса, лучше кастомный сделать либо напрямую юзать дио без этого класса
  Future<Response<T>> request<T>(RequestType type) async {
    return switch (type) {
      // Тут кстати так просто лайфхак, если у тебя возврщается Future, то не нужно писать return await _dio.get(), достаточно просто return _dio.get()
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
