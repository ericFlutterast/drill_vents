import 'dart:async';

import 'package:drill_events/common/ports/fast_cache.dart';

class _CacheEntry {
  _CacheEntry(this.value);

  Object value;
  Timer? timer;
}

class MapCache implements FastCache {
  final _cache = <String, _CacheEntry>{};
  final _miss = <String, int>{};

  @override
  T? get<T>(String key) {
    final entry = _cache[key];

    if (entry == null) {
      if (!_miss.containsKey(key)) {
        _miss[key] = 0;
      }
      _miss[key] = _miss[key]! + 1;
    }

    return entry?.value as T?;
  }

  @override
  void set<T extends Object>(String key, T value, {Duration? duration}) {
    _clearEntry(key);

    final newEntry = _CacheEntry(value);
    if (duration != null) {
      newEntry.timer = Timer(duration, () => _clearEntry(key));
    }

    _cache[key] = newEntry;
  }

  void _clearEntry(String key) {
    final entry = _cache[key];
    if (entry != null) {
      entry.timer?.cancel();
      entry.timer = null;
    }
    _cache.remove(key);
  }
}
