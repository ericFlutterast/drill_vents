import 'package:dio/dio.dart';
import 'package:drill_events/app/blocs/common_bloc_state.dart';
import 'package:drill_events/app/new_models/models.dart';
import 'package:drill_events/common/ports/backend_api.dart';
import 'package:drill_events/common/ports/logger.dart';
import 'package:drill_events/common/utils/error_codes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class EditEvent {
  const EditEvent({
    required this.eventId,
    this.title,
    this.capacity,
    this.description,
    this.endTime,
    this.startTime,
    this.startDate,
    this.spotId,
  });

  final String eventId;
  final String? spotId, title, description;
  final DateTime? startDate, startTime, endTime;
  final int? capacity;
}

typedef _Emit = Emitter;

final class EditEventBloc extends Bloc<EditEvent, CommonBlocState> {
  EditEventBloc({required Logger logger, required BackendAPI api})
    : _api = api,
      _logger = logger,

      super(const CommonBlocState.init()) {
    on<EditEvent>(_editEvent);
  }

  final Logger _logger;
  final BackendAPI _api;

  Future<void> _editEvent(EditEvent event, _Emit emit) async {
    try {
      emit(state.pending());

      final newEvent = NewEventModel(
        title: event.title,
        description: event.description,
        startDate: event.startDate,
        startTime: event.startTime,
        endTime: event.endTime,
        spotId: event.spotId,
        capacity: event.capacity,
      );

      await _api.updateEvent(event.eventId, eventData: newEvent);

      emit(state.done(null));
    } on DioException catch (error, stackTrace) {
      emit(state.error(error.appErrorMessage));
      _logger.error(error.appErrorMessage, error: error, stackTrace: stackTrace);
    } catch (error, stackTrace) {
      emit(state.error(error));
      _logger.error(error, error: error, stackTrace: stackTrace);
    }
  }
}
