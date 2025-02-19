import 'package:dio/dio.dart';
import 'package:drill_events/app/data/data_repository.dart';
import 'package:drill_events/common/di/dependencies.dart';
import 'package:drill_events/common/network/api_client.dart';

Future<void> initializer({
  required Function(double progres, String step) onProgress,
  required Function(Object error, StackTrace? stackTrace) onError,
  required Function(Dependencies dependencies) onSuccess,
}) async {
  try {
    final dependencies = Dependencies();
    double progress = 0;
    for (final entry in _dependenciesSteps.entries) {
      onProgress.call(progress, entry.key);
      await entry.value(dependencies);
      progress += 1.0 / _dependenciesSteps.length;
    }
    onSuccess(dependencies);
  } catch (error, stackTrace) {
    onError(error, stackTrace);
  }
}

typedef Loader = Future<void> Function(Dependencies dependencies);

Map<String, Loader> _dependenciesSteps = {
  'network': (dependencies) async {
    await Future.delayed(const Duration(seconds: 1));
    dependencies.httpApiClient = HttpApiClient(
      Dio(
        BaseOptions(
          baseUrl: 'http://drillevents.drillcorp.ru:8333',
          connectTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
        ),
      ),
    );
  },
  'repository': (dependencies) async {
    await Future.delayed(const Duration(seconds: 1));
    dependencies.repository = DataRepositoryImpl(dependencies.httpApiClient);
  },

  'какие-то штуки': (dependencies) async {
    await Future.delayed(const Duration(seconds: 1));
  },
  'хлам': (dependencies) async {
    await Future.delayed(const Duration(seconds: 1));
  },
  'вещи из моей кладовки': (dependencies) async {
    await Future.delayed(const Duration(seconds: 1));
  },
  'получение солнечной энергии': (dependencies) async {
    await Future.delayed(const Duration(seconds: 1));
  },
  'темная материя': (dependencies) async {
    await Future.delayed(const Duration(seconds: 1));
  },
};
