import 'package:dio/dio.dart';
import 'package:drill_events/app/blocs/common_bloc_state.dart';
import 'package:drill_events/app/new_models/models.dart';
import 'package:drill_events/common/ports/backend_api.dart';
import 'package:drill_events/common/ports/logger.dart';
import 'package:drill_events/common/utils/error_codes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///Event
final class CreateNewEvent {
  CreateNewEvent({
    required this.title,
    required this.capacity,
    required this.description,
    required this.endTime,
    required this.startTime,
    required this.startDate,
    required this.spotId,
  });

  final String spotId;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime startTime;
  final DateTime? endTime;
  final int capacity;
}

typedef CreateNewEventState = CommonBlocState<DetailEventModel>;
typedef Emit = Emitter<CreateNewEventState>;

///Bloc
final class CreateNewEventBloc extends Bloc<CreateNewEvent, CreateNewEventState> {
  CreateNewEventBloc(this._repository, this._logger) : super(const CreateNewEventState.init()) {
    on<CreateNewEvent>(_createNewEvent);
  }

  final BackendAPI _repository;
  final Logger _logger;

  Future<void> _createNewEvent(CreateNewEvent event, Emit emit) async {
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
      final result = await _repository.createEvent(newEvent);
      emit(state.done(result));
    } on DioException catch (error, stackTrace) {
      _logger.error(error.appErrorMessage, error: error, stackTrace: stackTrace);
      emit(state.error(error.appErrorMessage));
    } catch (error, stackTrace) {
      _logger.error(error, error: error, stackTrace: stackTrace);
      emit(state.error(error));
    } finally {
      emit(state.idle());
    }
  }
}
