import 'package:drill_events/common/logger/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class AppBlocObserver extends BlocObserver {
  final _log = Logger().log;

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    _log.i('Bloc: ${bloc.runtimeType}, $change');
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    _log.i('Bloc: ${bloc.runtimeType} was closed');
  }

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    _log.i('Bloc: ${bloc.runtimeType} was created');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    _log.e('Bloc: ${bloc.runtimeType} throw error', error: error, stackTrace: stackTrace);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    _log.i('Bloc: ${bloc.runtimeType} get event: $event');
  }
}
