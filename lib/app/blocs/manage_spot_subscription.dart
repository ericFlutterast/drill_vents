import 'package:dio/dio.dart';
import 'package:drill_events/app/blocs/common_bloc_state.dart';
import 'package:drill_events/common/ports/backend_api.dart';
import 'package:drill_events/common/ports/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///Events
abstract class ManageSpotSubscriptionEvent {
  const ManageSpotSubscriptionEvent(this.spotId);

  final String spotId;
}

final class SubscribeEvent extends ManageSpotSubscriptionEvent {
  SubscribeEvent(super.spotId);
}

final class UnsubscribeEvent extends ManageSpotSubscriptionEvent {
  UnsubscribeEvent(super.spotId);
}

///State
typedef ManageSpotSubscriptionState = CommonBlocState;
typedef _Emit = Emitter<ManageSpotSubscriptionState>;

final class ManageSpotSubscriptionBloc extends Bloc<ManageSpotSubscriptionEvent, ManageSpotSubscriptionState> {
  ManageSpotSubscriptionBloc({required Logger logger, required BackendAPI api})
    : _logger = logger,
      _api = api,
      super(const CommonBlocState.init()) {
    on<SubscribeEvent>(_subscribe);
    on<UnsubscribeEvent>(_unsubscribe);
  }

  final Logger _logger;
  final BackendAPI _api;

  Future<void> _subscribe(SubscribeEvent event, _Emit emit) async {
    try {
      emit(state.pending());
      await _api.subscribeToSpot(event.spotId);
      emit(state.done(null));
    } on DioException catch (error, stackTrace) {
      emit(state.error('Ошибка сети'));
      _logger.error('Ошибка сети', error: error, stackTrace: stackTrace);
    } catch (error, stackTrace) {
      emit(state.error(error));
      _logger.error(error, error: error, stackTrace: stackTrace);
    }
  }

  Future<void> _unsubscribe(UnsubscribeEvent event, _Emit emit) async {
    try {
      emit(state.pending());
      await _api.unsubscribeFromSpot(event.spotId);
      emit(state.done(null));
    } on DioException catch (error, stackTrace) {
      emit(state.error('Ошибка сети'));
      _logger.error('Ошибка сети', error: error, stackTrace: stackTrace);
    } catch (error, stackTrace) {
      emit(state.error(error));
      _logger.error(error, error: error, stackTrace: stackTrace);
    }
  }
}
