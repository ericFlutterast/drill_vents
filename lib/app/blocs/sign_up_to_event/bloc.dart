import 'package:drill_events/app/blocs/common_bloc_state.dart';
import 'package:drill_events/app/blocs/sign_up_to_event/events.dart';
import 'package:drill_events/common/ports/data_repository.dart';
import 'package:drill_events/common/ports/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef _State = CommonBlocState<String>;
typedef Emit = Emitter<_State>;

final class SignUpToEventBloc extends Bloc<SignUpToEvent, _State> {
  SignUpToEventBloc({required DataRepository repository, required Logger logger})
    : _repository = repository,
      _logger = logger,
      super(const CommonBlocState.init()) {
    on<SignUpEvent>(_fetchDetailEvent);
  }

  final DataRepository _repository;
  final Logger _logger;

  Future<void> _fetchDetailEvent(SignUpEvent event, Emit emit) async {
    try {
      emit(state.pending());
      await _repository.signUpToEvent(event.email);
      emit(state.done(null));
    } catch (error, stackTrace) {
      emit(state.error(error));
      _logger.error(error, error: error, stackTrace: stackTrace);
    }
  }
}
