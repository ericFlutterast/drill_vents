import 'package:dio/dio.dart';
import 'package:drill_events/app/blocs/common_bloc_state.dart';
import 'package:drill_events/app/new_models/models.dart';
import 'package:drill_events/common/ports/backend_api.dart';
import 'package:drill_events/common/ports/logger.dart';
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

typedef _State = CommonBlocState<BookingModel>;
typedef Emit = Emitter<_State>;

///Bloc
final class BookingEventBloc extends Bloc<BookingEvent, _State> {
  BookingEventBloc({required BackendAPI repository, required Logger logger})
    : _repository = repository,
      _logger = logger,

      super(const CommonBlocState.init()) {
    on<BookToEvent>(_createBook);
  }

  final BackendAPI _repository;
  final Logger _logger;

  Future<void> _createBook(BookToEvent event, Emit emit) async {
    try {
      emit(state.pending());
      final result = await _repository.bookEvent(event.eventId, event.userId);
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
