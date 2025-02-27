import 'package:drill_events/common/ports/logger.dart';
import 'package:logger/logger.dart' as l;

final class DefaultLogger implements Logger {
  final l.Logger _logger = l.Logger();

  @override
  void info(dynamic message) {
    _logger.i(message);
  }

  @override
  void error(dynamic message, {Object? error, StackTrace? stackTrace}) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }
}
