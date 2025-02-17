import 'package:logger/logger.dart' as l;

final class Logger {
  static final Logger _instance = Logger._();

  Logger._();

  factory Logger() => _instance;

  final _logger = l.Logger();

  l.Logger get log => _logger;
}
