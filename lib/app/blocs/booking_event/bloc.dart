import 'package:dio/dio.dart';
import 'package:drill_events/app/blocs/booking_event/events.dart';
import 'package:drill_events/app/blocs/common_bloc_state.dart';
import 'package:drill_events/app/new_models/models.dart';
import 'package:drill_events/common/adapters/events_pipe/pipe_events.dart';
import 'package:drill_events/common/ports/backend_api.dart';
import 'package:drill_events/common/ports/logger.dart';
import 'package:drill_events/common/ports/pipe.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef _State = CommonBlocState<BookingModel>;
typedef Emit = Emitter<_State>;

final class BookingEventBloc extends Bloc<BookingEvent, _State> {
  BookingEventBloc({required BackendAPI repository, required Logger logger, required Pipe pipe})
    : _repository = repository,
      _logger = logger,
      _pipe = pipe,
      super(const CommonBlocState.init()) {
    on<BookToEvent>(_signUpBloc);

    _pipe.listen((pipeEvent) {
      if (pipeEvent is UserIsReceived) {
        add(BookToEvent(email: pipeEvent.email));
      }
    });
  }

  final BackendAPI _repository;
  final Logger _logger;
  final Pipe _pipe;

  Future<void> _signUpBloc(BookToEvent event, Emit emit) async {
    try {
      emit(state.pending());
      //TODO:
      final result = await _repository.bookEvent('', '');
      emit(state.done(result));
    } on DioException catch (error, stackTrace) {
      emit(state.error(error.message ?? 'Сетевая ошибка'));
      _logger.error(error, error: error, stackTrace: stackTrace);
    } catch (error, stackTrace) {
      emit(state.error(error));
      _logger.error(error, error: error, stackTrace: stackTrace);
    }
  }
}
