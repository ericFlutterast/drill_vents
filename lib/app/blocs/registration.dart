import 'package:dio/dio.dart';
import 'package:drill_events/app/blocs/common_bloc_state.dart';
import 'package:drill_events/common/ports/backend_api.dart';
import 'package:drill_events/common/ports/logger.dart';
import 'package:drill_events/common/ports/pipe.dart';
import 'package:drill_events/common/utils/error_codes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class CreateUserEvent {
  CreateUserEvent({required this.email, required this.password});

  final String email, password;
}

typedef Uid = String;
typedef _State = CommonBlocState<Uid>;
typedef _Emit = Emitter<_State>;

final class RegistrationBloc extends Bloc<CreateUserEvent, _State> {
  RegistrationBloc({required BackendAPI repository, required Logger logger, required Pipe pipe})
    : _logger = logger,
      _repository = repository,
      super(const CommonBlocState.init()) {
    on<CreateUserEvent>(_createUser);
  }

  final BackendAPI _repository;
  final Logger _logger;

  Future<void> _createUser(CreateUserEvent event, _Emit emit) async {
    try {
      emit(state.pending());
      final userId = await _repository.createUser(email: event.email, password: event.password);
      emit(state.done(userId));
    } on DioException catch (error, stackTrace) {
      emit(state.error(error.appErrorMessage));
      _logger.error(error.appErrorMessage, error: error, stackTrace: stackTrace);
    } catch (error, stackTrace) {
      emit(state.error(error));
      _logger.error(error, error: error, stackTrace: stackTrace);
    }
  }
}
