abstract interface class Logger {
  void info(dynamic message);
  void error(dynamic message, {Object? error, StackTrace? stackTrace});
}
