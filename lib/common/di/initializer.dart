import 'package:dio/dio.dart';
import 'package:drill_events/app/blocs/auth.dart';
import 'package:drill_events/app/blocs/booking_event/bloc.dart';
import 'package:drill_events/app/blocs/create_new_event.dart';
import 'package:drill_events/app/blocs/detail_event/bloc.dart';
import 'package:drill_events/app/blocs/events/bloc.dart';
import 'package:drill_events/app/blocs/receiving_spots.dart';
import 'package:drill_events/app/blocs/registration.dart';
import 'package:drill_events/app/data/main_backend_api.dart';
import 'package:drill_events/common/adapters/events_pipe/events_pipe.dart';
import 'package:drill_events/common/cache/map_cache.dart';
import 'package:drill_events/common/di/dependencies.dart';
import 'package:drill_events/common/logger/default_logger.dart';
import 'package:drill_events/common/network/http_api_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
    dependencies.pipe = EventsPipe();
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
    dependencies.secureStorage = const FlutterSecureStorage();
    dependencies.backendApi = MainBackendAPI(dependencies.httpApiClient, dependencies.logger);
    dependencies.sharedPreferences = await SharedPreferences.getInstance();
  },
  'blocs': (dependencies) async {
    dependencies.authBloc = AuthBloc(
      repository: dependencies.backendApi,
      secureStorage: dependencies.secureStorage,
      logger: dependencies.logger,
    );
    dependencies.eventsBloc = EventsBloc(dependencies.backendApi, dependencies.logger);
    dependencies.signUpToEventBloc = BookingEventBloc(
      repository: dependencies.backendApi,
      logger: dependencies.logger,
      pipe: dependencies.pipe,
    );
    dependencies.detailEventBloc = DetailEventBloc(
      dependencies.fastCache,
      dependencies.backendApi,
      dependencies.logger,
    );
    dependencies.registrationBloc = RegistrationBloc(
      repository: dependencies.backendApi,
      logger: dependencies.logger,
      pipe: dependencies.pipe,
    );
    dependencies.receivingSpotsBloc = ReceivingSpotsBloc(dependencies.backendApi, dependencies.logger);
    dependencies.createNewEventBloc = CreateNewEventBloc(dependencies.backendApi, dependencies.logger);
  },
};
