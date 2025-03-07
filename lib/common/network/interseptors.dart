import 'package:dio/dio.dart';
import 'package:drill_events/common/secure_storage/secure_storage_keys.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final class AuthInterceptor extends Interceptor {
  const AuthInterceptor(this._flutterSecureStorage);

  final FlutterSecureStorage _flutterSecureStorage;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _flutterSecureStorage.read(key: SecureStorageKeys.accessToken);
    options.headers = {'Authorization': 'Bearer $token'};
    handler.next(options);
    super.onRequest(options, handler);
  }
}
