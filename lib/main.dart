import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart' as bloc_concurrency;
import 'package:drill_events/app/app.dart';
import 'package:drill_events/common/bloc/bloc_observer.dart';
import 'package:drill_events/common/di/dependencies.dart';
import 'package:drill_events/common/di/dependencies_scope.dart';
import 'package:drill_events/common/di/initializer.dart';
import 'package:drill_events/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

void main() => runZonedGuarded(
  () async {
    WidgetsFlutterBinding.ensureInitialized();
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    initializer(
      onProgress: onProgress,
      onError: onError,
      onSuccess: (Dependencies dependencies) {
        WidgetsFlutterBinding.ensureInitialized();

        Bloc.observer = AppBlocObserver(dependencies.logger);
        Bloc.transformer = bloc_concurrency.sequential();

        runApp(DependenciesScope(dependencies: dependencies, child: const App()));
      },
    );
  },
  (error, stackTrace) {
    Logger().e(error, error: error, stackTrace: stackTrace);
  },
);

void onProgress(double progress, String step) {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Загрузка...: $step'),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey,
                color: Colors.black,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              const SizedBox(height: 10),
              Text('${(progress * 100).toStringAsFixed(1)}%'),
            ],
          ),
        ),
      ),
    ),
  );
}

void onError(Object error, StackTrace? stackTrace) {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          color: Colors.red,
          child: Center(
            child: Text(
              textAlign: TextAlign.center,
              'Возникла ошибка: $error, попробуйте перезагрузить приложение',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
      ),
    ),
  );
}
