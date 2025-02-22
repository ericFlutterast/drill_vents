import 'package:drill_events/common/ports/logger.dart';
import 'package:logger/logger.dart';

final class DefaultLogger implements DrillLogger {
  final Logger _logger = Logger();

  @override
  void info(dynamic message) {
    _logger.i(message);
  }

  @override
  void error(dynamic message, {Object? error, StackTrace? stackTrace}) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }
}
