import 'package:dio/dio.dart';

/// App error codes
abstract class ErrorCodes {
  static const _codesMap = <int, String>{
    // 0-99 - System
    0: 'Unknown error',
    1: 'Invalid body',
    2: 'Invalid request',
    3: 'Not found',
    // 100-199 - Authorization
    100: 'Token unknown error',
    101: 'Token is unauthorized',
    102: 'Token is expired',
    103: 'No token provided',
    110: 'Incorrect password or email',
    111: 'User already exists',
    // 200-299 - Events
    // 300-399 - Spots
    300: 'Spot unknown error',
    301: 'User is already subscribed',
    // 400-499 - 0rgs
  };

  static String message(int? code) => _codesMap[code] ?? 'Ошибка подключения';
}

extension GetErrorMessage on DioException {
  String get appErrorMessage {
    final code = response?.data['code'];
    return ErrorCodes.message(code);
  }
}
