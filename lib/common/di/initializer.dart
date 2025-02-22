import 'package:dio/dio.dart';
import 'package:drill_events/app/blocs/detail_event/bloc.dart';
import 'package:drill_events/app/blocs/events/bloc.dart';
import 'package:drill_events/app/blocs/sign_up_to_event/bloc.dart';
import 'package:drill_events/app/data/data_repository.dart';
import 'package:drill_events/common/cache/map_cache.dart';
import 'package:drill_events/common/di/dependencies.dart';
import 'package:drill_events/common/logger/default_logger.dart';
import 'package:drill_events/common/network/http_api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  'utils': (dependencies) async {
    dependencies.logger = DefaultLogger();
    dependencies.fastCache = MapCache();
  },
  'network': (dependencies) async {
    dependencies.httpApiClient = HttpApiClient(
      Dio(
        BaseOptions(
          baseUrl: 'http://drillevents.drillcorp.ru:8000',
          connectTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
        ),
      ),
    );
  },
  'data': (dependencies) async {
    dependencies.repository = BackendDataRepository(dependencies.httpApiClient);
    dependencies.sharedPreferences = await SharedPreferences.getInstance();
  },
  'blocs': (dependencies) async {
    dependencies.eventsBloc = EventsBloc(dependencies.repository, dependencies.logger);
    dependencies.signUpToEventBloc = SignUpToEventBloc(
      repository: dependencies.repository,
      sharedPreferences: dependencies.sharedPreferences,
      logger: dependencies.logger,
    );
    dependencies.detailEventBloc = DetailEventBloc(
      dependencies.fastCache,
      dependencies.repository,
      dependencies.logger,
    );
  },
};
