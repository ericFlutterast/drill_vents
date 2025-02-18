part of 'api_client.dart';

sealed class RequestType {
  const RequestType._(
    this.path,
    this.data,
    this.queryParameters,
    this.cancelToken,
    this.options, {
    this.onReceiveProgress,
    this.onSendProgress,
  });

  factory RequestType.get({
    required String path,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    Function(int, int)? onReceiveProgress,
  }) = _Get;

  factory RequestType.post({
    required String path,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    Function(int, int)? onReceiveProgress,
    Function(int, int)? onSendProgress,
  }) = _Post;

  factory RequestType.delete({
    required String path,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) = _Delete;

  factory RequestType.patch({
    required String path,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    Function(int, int)? onReceiveProgress,
    Function(int, int)? onSendProgress,
  }) = _Patch;

  factory RequestType.put({
    required String path,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    Function(int, int)? onReceiveProgress,
    Function(int, int)? onSendProgress,
  }) = _Put;

  final String path;
  final Object? data;
  final Map<String, dynamic>? queryParameters;
  final Options? options;
  final CancelToken? cancelToken;
  final Function(int, int)? onReceiveProgress;
  final Function(int, int)? onSendProgress;
}

///TYPES
final class _Get extends RequestType {
  const _Get({
    required String path,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    Function(int, int)? onReceiveProgress,
  }) : super._(path, data, queryParameters, cancelToken, options, onReceiveProgress: onReceiveProgress);
}

final class _Post extends RequestType {
  const _Post({
    required String path,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    Function(int, int)? onReceiveProgress,
    Function(int, int)? onSendProgress,
  }) : super._(
         path,
         data,
         queryParameters,
         cancelToken,
         options,
         onReceiveProgress: onReceiveProgress,
         onSendProgress: onSendProgress,
       );
}

final class _Put extends RequestType {
  const _Put({
    required String path,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    Function(int, int)? onReceiveProgress,
    Function(int, int)? onSendProgress,
  }) : super._(
         path,
         data,
         queryParameters,
         cancelToken,
         options,
         onReceiveProgress: onReceiveProgress,
         onSendProgress: onSendProgress,
       );
}

final class _Patch extends RequestType {
  const _Patch({
    required String path,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    Function(int, int)? onReceiveProgress,
    Function(int, int)? onSendProgress,
  }) : super._(
         path,
         data,
         queryParameters,
         cancelToken,
         options,
         onReceiveProgress: onReceiveProgress,
         onSendProgress: onSendProgress,
       );
}

final class _Delete extends RequestType {
  const _Delete({
    required String path,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) : super._(path, data, queryParameters, cancelToken, options);
}
