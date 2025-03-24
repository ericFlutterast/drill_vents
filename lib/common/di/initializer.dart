import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:drill_events/app/data/main_backend_api.dart';
import 'package:drill_events/common/adapters/events_pipe/events_pipe.dart';
import 'package:drill_events/common/adapters/file_firebase_storage.dart';
import 'package:drill_events/common/cache/map_cache.dart';
import 'package:drill_events/common/di/dependencies.dart';
import 'package:drill_events/common/logger/default_logger.dart';
import 'package:drill_events/common/network/http_api_client.dart';
import 'package:drill_events/common/network/interseptors.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
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
  'secure-storage': (dependencies) async {
    dependencies.secureStorage = const FlutterSecureStorage();
  },
  'network': (dependencies) async {
    final dioClient = Dio(
      BaseOptions(
        baseUrl: 'https://drillevents.drillcorp.ru:8000',
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
      ),
    );

    (dioClient.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final httpClient = HttpClient();
      httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return httpClient;
    };

    final authInterceptor = AuthInterceptor(dependencies.secureStorage);
    dioClient.interceptors.add(authInterceptor);

    dependencies.httpApiClient = HttpApiClient(dioClient);
  },
  'data': (dependencies) async {
    dependencies.backendApi = MainBackendAPI(api: dependencies.httpApiClient, pipe: dependencies.pipe);
    dependencies.sharedPreferences = await SharedPreferences.getInstance();
  },
  'File manager': (dependencies) async {
    dependencies.imagePicker = ImagePicker();
    dependencies.fileStorage = FileFirebaseStorage(FirebaseStorage.instance, dependencies.logger);
  },
};
