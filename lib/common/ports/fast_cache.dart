abstract interface class FastCache {
  T? get<T>(String key);
  void set<T>(String key, T value, {Duration? duration});
}
