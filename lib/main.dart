import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart' as bloc_concurrency;
import 'package:drill_events/app/app.dart';
import 'package:drill_events/common/bloc/bloc_observer.dart';
import 'package:drill_events/common/logger/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runZonedGuarded(
  () {
    Bloc.observer = AppBlocObserver();
    Bloc.transformer = bloc_concurrency.sequential();

    runApp(const App());
  },
  (error, stackTrace) {
    Logger().log.e(error, error: error, stackTrace: stackTrace);
  },
);
