import 'package:dio/dio.dart';
import 'package:drill_events/app/blocs/events/bloc.dart';
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
      progress += 1.0 / _dependenciesSteps.length;
      onProgress.call(progress, entry.key);
      await entry.value(dependencies);
    }
    onSuccess(dependencies);
  } catch (error, stackTrace) {
    onError(error, stackTrace);
  }
}

typedef Loader = Future<void> Function(Dependencies dependencies);

Map<String, Loader> _dependenciesSteps = {
  'network': (dependencies) async {
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
    dependencies.repository = DataRepositoryImpl(dependencies.httpApiClient);
  },
  'вещи из моей кладовки': (dependencies) async {
    await Future.delayed(const Duration(seconds: 1));
    dependencies.eventsBloc = EventsBloc(repository: dependencies.repository);
  },
  'получение солнечной энергии': (dependencies) async {
    await Future.delayed(const Duration(seconds: 1));
  },
  'темная материя': (dependencies) async {
    await Future.delayed(const Duration(seconds: 1));
  },
};
