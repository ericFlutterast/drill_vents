import 'package:dio/dio.dart';
import 'package:drill_events/app/blocs/common_bloc_state.dart';
import 'package:drill_events/app/blocs/sign_up_to_event/events.dart';
import 'package:drill_events/common/adapters/events_pipe/pipe_events.dart';
import 'package:drill_events/common/ports/data_repository.dart';
import 'package:drill_events/common/ports/logger.dart';
import 'package:drill_events/common/ports/pipe.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef _State = CommonBlocState<String>;
typedef Emit = Emitter<_State>;

final class SignUpToEventBloc extends Bloc<SignUpToEvent, _State> {
  SignUpToEventBloc({required DataRepository repository, required Logger logger, required Pipe pipe})
    : _repository = repository,
      _logger = logger,
      _pipe = pipe,
      super(const CommonBlocState.init()) {
    on<SignUpEvent>(_signUpBloc);

    _pipe.listen((pipeEvent) {
      if (pipeEvent is UserIsReceived) {
        add(SignUpEvent(email: pipeEvent.email));
      }
    });
  }

  final DataRepository _repository;
  final Logger _logger;
  final Pipe _pipe;

  Future<void> _signUpBloc(SignUpEvent event, Emit emit) async {
    try {
      emit(state.pending());
      final result = await _repository.signUpToEvent(event.email);
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
