import 'package:drill_events/app/blocs/common_bloc_state.dart';
import 'package:drill_events/app/blocs/registration/events.dart';
import 'package:drill_events/common/ports/data_repository.dart';
import 'package:drill_events/common/ports/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef _State = CommonBlocState<String>;
typedef _Emit = Emitter<_State>;

final class RegistrationBloc extends Bloc<RegistrationEvent, _State> {
  RegistrationBloc({required DataRepository repository, required Logger logger})
    : _logger = logger,
      _repository = repository,
      super(const CommonBlocState.init()){
    on<CreateUserEvent>(_createUser);
  }

  final DataRepository _repository;
  final Logger _logger;

  Future<void> _createUser(CreateUserEvent event, _Emit emit) async {
    try {
      emit(state.pending());
      final userId = await _repository.createUser(email: event.email, password: event.password);
      emit(state.done(userId));
    } catch (error, stackTrace) {
      emit(state.error(error));
      _logger.error(error, error: error, stackTrace: stackTrace);
    }
  }
}
