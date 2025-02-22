abstract interface class DrillLogger {
  void info(dynamic message);
  void error(dynamic message, {Object? error, StackTrace? stackTrace});
}
