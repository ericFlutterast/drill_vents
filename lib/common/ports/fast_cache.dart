abstract interface class FastCache {
  T? get<T>(String key);
  void set<T extends Object>(String key, T value, {Duration? duration});
}
