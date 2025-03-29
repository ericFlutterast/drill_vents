import 'package:dio/dio.dart';
import 'package:drill_events/app/blocs/common_bloc_state.dart';
import 'package:drill_events/app/new_models/models.dart';
import 'package:drill_events/common/adapters/events_pipe/pipe_events.dart';
import 'package:drill_events/common/ports/backend_api.dart';
import 'package:drill_events/common/ports/fast_cache.dart';
import 'package:drill_events/common/ports/logger.dart';
import 'package:drill_events/common/ports/pipe.dart';
import 'package:drill_events/common/utils/error_codes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///Events
abstract class BookingEvent {
  const BookingEvent();
}

final class BookToEvent extends BookingEvent {
  const BookToEvent({required this.eventId, required this.userId});

  final String eventId, userId;
}

final class RemoveBookEvent extends BookingEvent {
  const RemoveBookEvent({required this.eventId, required this.userId});

  final String eventId, userId;
}

typedef BookingEventState = CommonBlocState<BookingModel>;
typedef Emit = Emitter<BookingEventState>;

///Bloc
final class BookingEventBloc extends Bloc<BookingEvent, BookingEventState> {
  BookingEventBloc({
    required BackendAPI repository,
    required Logger logger,
    required Pipe pipe,
    required FastCache cache,
  }) : _repository = repository,
       _logger = logger,
       _pipe = pipe,
       _cache = cache,
       super(const CommonBlocState.init()) {
    on<BookToEvent>(_createBook);
    on<RemoveBookEvent>(_removeBook);
  }

  final BackendAPI _repository;
  final Logger _logger;
  final Pipe _pipe;
  final FastCache _cache;

  Future<void> _createBook(BookToEvent event, Emit emit) async {
    try {
      emit(state.pending());
      final result = await _repository.bookEvent(event.eventId, event.userId);
      _cache.clear();
      _pipe.publish(UpdateEventsInfo());
      emit(state.done(result));
    } on DioException catch (error, stackTrace) {
      emit(state.error(error.appErrorMessage));
      _logger.error(error.appErrorMessage, error: error, stackTrace: stackTrace);
    } catch (error, stackTrace) {
      emit(state.error(error));
      _logger.error(error, error: error, stackTrace: stackTrace);
    }
  }

  Future<void> _removeBook(RemoveBookEvent event, Emit emit) async {
    try {
      emit(state.pending());
      final result = await _repository.unbook(event.eventId, event.userId);
      _cache.clear();
      _pipe.publish(UpdateEventsInfo());
      emit(state.done(result));
    } on DioException catch (error, stackTrace) {
      emit(state.error(error.appErrorMessage));
      _logger.error(error.appErrorMessage, error: error, stackTrace: stackTrace);
    } catch (error, stackTrace) {
      emit(state.error(error));
      _logger.error(error, error: error, stackTrace: stackTrace);
    }
  }
}
